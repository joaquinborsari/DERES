import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:topicos/supplier/models/supplier_model.dart';

enum SupplierStatus { initial, success, failure, loading }

@immutable
class SupplierState extends Equatable {
  const SupplierState({
    required this.suppliers,
    required this.name,
    required this.rut,
    required this.score,
    required this.status,
  });

  const SupplierState.initial()
      : this(
            suppliers: const <Supplier>[],
            name: '',
            rut: '',
            score: '',
            status: SupplierStatus.initial);

  final List<Supplier> suppliers;
  final String name;
  final String rut;
  final String score;
  final SupplierStatus status;

  List<Supplier> get filteredSuppliers => _filterSuppliers();

  @override
  List<Object?> get props => [
        suppliers,
        name,
        rut,
        score,
        status,
      ];

  SupplierState copyWith(
      {List<Supplier>? suppliers,
      String? name,
      String? rut,
      String? score,
      SupplierStatus? status}) {
    return SupplierState(
        suppliers: suppliers ?? this.suppliers,
        name: name ?? this.name,
        score: score ?? this.score,
        rut: rut ?? this.rut,
        status: status ?? this.status);
  }

  List<Supplier> _filterSuppliers() {
    return suppliers.where((supplier) {
      bool nameMatch = name.isEmpty ? true : supplier.name.contains(name);
      bool rutMatch = rut.isEmpty ? true : supplier.rut.contains(rut);
      bool scoreMatch = score.isEmpty ? true : supplier.score.contains(score);

      return nameMatch && rutMatch && scoreMatch;
    }).toList();
  }
}
