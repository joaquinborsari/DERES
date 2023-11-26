import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:topicos/admin/model/poll.dart';
import 'package:topicos/company/model/company_data.dart';

enum CompanyStatus {
  initial,
  inProgress,
  success,
  pollSuccess,
  failure,
}

@immutable
class CompanyState extends Equatable {
  const CompanyState({
    required this.poll,
    required this.status,
    required this.selectedQuestions,
    required this.companyData,
  });

  CompanyState.initial()
      : this(
            poll: const <Poll>[],
            status: CompanyStatus.initial,
            selectedQuestions: const <String, bool>{},
            companyData: CompanyData.empty());

  @override
  List<Object?> get props => [poll, status, selectedQuestions, companyData];

  final List<Poll> poll;
  final CompanyStatus status;
  final Map<String, bool> selectedQuestions;
  final CompanyData companyData;

  CompanyState copyWith(
      {List<Poll>? poll,
      CompanyStatus? status,
      Map<String, bool>? selectedQuestions,
      CompanyData? companyData}) {
    return CompanyState(
      poll: poll ?? this.poll,
      status: status ?? this.status,
      selectedQuestions: selectedQuestions ?? this.selectedQuestions,
      companyData: companyData ?? this.companyData,
    );
  }
}
