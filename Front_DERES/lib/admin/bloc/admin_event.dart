import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:topicos/admin/bloc/admin_state.dart';

@immutable
abstract class AdminEvent extends Equatable {
  const AdminEvent();
}

class AdminQuestionChanged extends AdminEvent {
  const AdminQuestionChanged({
    required this.question,
  });

  final String question;
  @override
  List<Object?> get props => [question];
}

class AdminQuestionTypeChanged extends AdminEvent {
  const AdminQuestionTypeChanged({
    required this.questionType,
  });

  final QuestionType questionType;
  @override
  List<Object?> get props => [questionType];
}

class AdminQuestionSubmitted extends AdminEvent {
  const AdminQuestionSubmitted();

  @override
  List<Object?> get props => [];
}

class AdminQuestionAdd extends AdminEvent {
  const AdminQuestionAdd();

  @override
  List<Object?> get props => [];
}

class AdminQuestionRequested extends AdminEvent {
  const AdminQuestionRequested();

  @override
  List<Object?> get props => [];
}

class AdminEditQuestion extends AdminEvent {
  const AdminEditQuestion(
      {required this.questionId,
      required this.ponderation,
      required this.questionType});
  final int questionId;
  final String ponderation;
  final QuestionType questionType;

  @override
  List<Object?> get props => [questionId, ponderation, questionId];
}
