import 'package:topicos/admin/bloc/admin_state.dart';

class Question {
  final String questionText;
  final QuestionType type;
  String ponderation;
  final int id;

  Question({
    required this.questionText,
    required this.type,
    required this.ponderation,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': questionText,
      'type': type.name.toUpperCase(),
      'ponderation': ponderation,
      'id': id,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        questionText: json['question'] as String,
        type: QuestionTypeExtension.fromString(json['type'] as String),
        ponderation: json['ponderation'] as String,
        id: json['id'] as int);
  }
}
