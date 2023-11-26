import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:topicos/admin/model/poll.dart';
import 'package:topicos/admin/model/question.dart';

enum QuestionType { social, environmental, governance }

extension QuestionTypeName on QuestionType {
  String get name {
    switch (this) {
      case QuestionType.social:
        return 'Social';
      case QuestionType.environmental:
        return 'Ambiental';
      case QuestionType.governance:
        return 'Gobernanza';
    }
  }
}

extension QuestionTypeExtension on QuestionType {
  static QuestionType fromString(String typeAsString) {
    switch (typeAsString) {
      case 'SOCIAL':
        return QuestionType.social;
      case 'AMBIENTAL':
        return QuestionType.environmental;
      case 'GOBERNANZA':
        return QuestionType.governance;

      default:
        throw ArgumentError('Unknown QuestionType: $typeAsString');
    }
  }

  static String toStringQuestion(String typeAsString) {
    switch (typeAsString) {
      case 'SOCIAL':
        return QuestionType.social.name;
      case 'AMBIENTAL':
        return QuestionType.environmental.name;
      case 'GOBERNANZA':
        return QuestionType.governance.name;

      default:
        throw ArgumentError('Unknown QuestionType: $typeAsString');
    }
  }
}

enum AdminStatus {
  initial,
  inProgress,
  success,
  pollSuccess,
  failure,
}

@immutable
class AdminState extends Equatable {
  const AdminState({
    required this.question,
    required this.questionType,
    required this.status,
    required this.questions,
    required this.poll,
  });

  const AdminState.initial()
      : this(
            question: '',
            questionType: QuestionType.environmental,
            status: AdminStatus.initial,
            questions: const [],
            poll: const []);

  final String question;
  final QuestionType questionType;
  final AdminStatus status;
  final List<Question> questions;
  final List<Poll> poll;

  @override
  List<Object?> get props => [
        question,
        questionType,
        status,
        question,
        poll,
      ];

  Map<QuestionType, int>? calculatePonderation() {
    Map<QuestionType, int> typePonderationSum = {
      QuestionType.environmental: 0,
      QuestionType.social: 0,
      QuestionType.governance: 0,
    };

    for (var poll in poll) {
      for (var question in poll.questions) {
        int currentPonderation = int.tryParse(question.ponderation) ?? 0;
        int existingPonderation = typePonderationSum[question.type] ?? 0;

        if (existingPonderation + currentPonderation > 100) {
          continue;
        }

        typePonderationSum[question.type] =
            existingPonderation + currentPonderation;
      }
    }
    return typePonderationSum;
  }

  AdminState copyWith({
    String? question,
    QuestionType? questionType,
    AdminStatus? status,
    List<Question>? questions,
    List<Poll>? poll,
  }) {
    return AdminState(
      question: question ?? this.question,
      questionType: questionType ?? this.questionType,
      status: status ?? this.status,
      questions: questions ?? this.questions,
      poll: poll ?? this.poll,
    );
  }
}
