import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:topicos/supplier/bloc/supplier_event.dart';
import 'package:topicos/supplier/bloc/supplier_state.dart';
import 'package:topicos/supplier/models/supplier_model.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  SupplierBloc() : super(const SupplierState.initial()) {
    on<SupplierRequested>(_onSupplierRequested);
    on<SupplierNameChanged>(_onSupplierNameChanged);
    on<SupplierRutChanged>(_onSupplierRutChanged);
    on<SupplierScoreChanged>(_onSupplierScoreChanged);
  }

  FutureOr<void> _onSupplierRequested(
      SupplierRequested event, Emitter<SupplierState> emit) async {
    try {
      emit(state.copyWith(status: SupplierStatus.loading));
      List<Supplier> suppliers = await fetchSuppliers();
      emit(
          state.copyWith(suppliers: suppliers, status: SupplierStatus.success));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: SupplierStatus.failure));
    }
  }

  FutureOr<void> _onSupplierNameChanged(
      SupplierNameChanged event, Emitter<SupplierState> emit) {
    emit(state.copyWith(name: event.name));
  }

  FutureOr<void> _onSupplierRutChanged(
      SupplierRutChanged event, Emitter<SupplierState> emit) {
    emit(state.copyWith(rut: event.rut));
  }

  FutureOr<void> _onSupplierScoreChanged(
      SupplierScoreChanged event, Emitter<SupplierState> emit) {
    emit(state.copyWith(score: event.score));
  }

  Future<List<Supplier>> fetchSuppliers() async {
    final response =
        await http.get(Uri.parse('http://172.178.74.246:8080/providers'));

    if (response.statusCode == 202) {
      List<dynamic> jsonResponse = jsonDecode(
        response.body,
      );
      List<Supplier> suppliers =
          jsonResponse.map((data) => Supplier.fromJson(data)).toList();
      return suppliers;
    } else {
      throw Exception('Failed to load suppliers');
    }
  }
}
