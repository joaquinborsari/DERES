import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CompanyEvent extends Equatable {
  const CompanyEvent();
}

class CompanyQuestionChanged extends CompanyEvent {
  const CompanyQuestionChanged({
    required this.id,
    required this.selectedQuestion,
  });

  final int id;
  final bool selectedQuestion;

  @override
  List<Object?> get props => [id, selectedQuestion];
}

class CompanyQuestionRequested extends CompanyEvent {
  const CompanyQuestionRequested();

  @override
  List<Object?> get props => [];
}

class CompanyQuestionSubmitted extends CompanyEvent {
  const CompanyQuestionSubmitted();

  @override
  List<Object?> get props => [];
}

class CompanyInformationRequest extends CompanyEvent {
  const CompanyInformationRequest();

  @override
  List<Object?> get props => [];
}
