import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topicos/admin/bloc/admin_bloc.dart';
import 'package:topicos/admin/model/poll.dart';
import 'package:topicos/company/bloc/company_event.dart';
import 'package:topicos/company/bloc/company_state.dart';
import 'package:topicos/company/model/company_data.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  CompanyBloc() : super(CompanyState.initial()) {
    on<CompanyQuestionChanged>(_onQuestionChanged);
    on<CompanyQuestionRequested>(_onQuestionRequested);
    on<CompanyQuestionSubmitted>(_onQuestionSubmitted);
    on<CompanyInformationRequest>(_onCompanyInformationRequest);
  }

  FutureOr<void> _onQuestionChanged(
      CompanyQuestionChanged event, Emitter<CompanyState> emit) {
    final questionsMap = Map<String, bool>.from(state.selectedQuestions);
    questionsMap[event.id.toString()] = event.selectedQuestion;
    emit(state.copyWith(selectedQuestions: questionsMap));
  }

  FutureOr<void> _onQuestionRequested(
      CompanyQuestionRequested event, Emitter<CompanyState> emit) async {
    try {
      final poll = await fetchPolls();
      final mapQuestions = await createQuestionMap(poll);

      emit(state.copyWith(poll: poll, selectedQuestions: mapQuestions));
      emit(state.copyWith(status: CompanyStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CompanyStatus.failure));
    }
  }

  Future<Map<int, bool>> getAnswers() async {
    final providerRut = await getProviderId();
    var url = Uri.parse('http://172.178.74.246:8080/answers/$providerRut');
    var response = await http.get(url);
    if (response.statusCode == 202) {
      List<dynamic> data = jsonDecode(response.body);
      Map<int, bool> answersMap = {};
      for (var item in data) {
        answersMap[item['question_id']] = item['answer'];
      }
      return answersMap;
    } else {
      throw Exception('Error al obtener respuestas: ${response.statusCode}');
    }
  }

  Future<Map<String, bool>> createQuestionMap(
    List<Poll> polls,
  ) async {
    Map<String, bool> questionMap = {};
    Map<int, bool> answersMap = await getAnswers();

    for (var poll in polls) {
      for (var question in poll.questions) {
        questionMap[question.id.toString()] = answersMap[question.id] ?? false;
      }
    }

    return questionMap;
  }

  FutureOr<void> _onQuestionSubmitted(
      CompanyQuestionSubmitted event, Emitter<CompanyState> emit) async {
    final providerRut = await getProviderId();
    var url = Uri.parse('http://172.178.74.246:8080/answers/$providerRut');
    var client = http.Client();
    final json = await createListFromMap(state.selectedQuestions);
    final body = jsonEncode({'questions': json});
    final response = await client.post(
      url,
      body: body,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      emit(state.copyWith(status: CompanyStatus.pollSuccess));
    } else {
      emit(state.copyWith(status: CompanyStatus.failure));
    }
  }

  Future<List<Map<String, dynamic>>> createListFromMap(
      Map<String, bool> questionsMap) async {
    List<Map<String, dynamic>> dataList = [];
    final providerRut = await getProviderId();
    questionsMap.forEach((questionId, answer) {
      dataList.add({
        'answer': answer,
        'question_id': int.parse(questionId),
        'provider_rut': providerRut,
      });
    });

    return dataList;
  }

  Future<String?> getProviderId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('providerId');
  }

  FutureOr<void> _onCompanyInformationRequest(
      CompanyInformationRequest event, Emitter<CompanyState> emit) async {
    final providerRut = await getProviderId();
    var url = Uri.parse(
        'http://172.178.74.246:8080/providers/$providerRut'); // Reemplaza con la URL de tu API
    var response = await http.get(url);
    emit(state.copyWith(status: CompanyStatus.inProgress));
    if (response.statusCode == 202) {
      final data = jsonDecode(response.body);
      final companyData = CompanyData(
        name: data['name'],
        email: data['email'],
        address: data['address'] ?? '',
        phone: data['phone'],
        rut: data['rut'].toString(),
        score: data['score'] ?? '0',
        type: data['type'],
      );
      emit(state.copyWith(companyData: companyData));
    } else {
      emit(state.copyWith(status: CompanyStatus.failure));
    }
  }
}
