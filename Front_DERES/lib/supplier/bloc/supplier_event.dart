import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SupplierEvent extends Equatable {
  const SupplierEvent();
}

class SupplierRequested extends SupplierEvent {
  const SupplierRequested();
  @override
  List<Object?> get props => [];
}

class SupplierNameChanged extends SupplierEvent {
  const SupplierNameChanged({required this.name});
  final String name;
  @override
  List<Object?> get props => [name];
}

class SupplierRutChanged extends SupplierEvent {
  const SupplierRutChanged({required this.rut});
  final String rut;
  @override
  List<Object?> get props => [rut];
}

class SupplierScoreChanged extends SupplierEvent {
  const SupplierScoreChanged({required this.score});
  final String score;
  @override
  List<Object?> get props => [score];
}
