import 'package:topicos/admin/bloc/admin_state.dart';
import 'package:topicos/admin/model/question.dart';

class Poll {
  List<Question> questions;
  final QuestionType questionType;

  Poll({required this.questions, required this.questionType});

  factory Poll.fromJson(Map<String, dynamic> json) {
    var questionsJson = json['questions'] as List<dynamic>;
    List<Question> questionsList = questionsJson
        .map((questionJson) => Question.fromJson(questionJson))
        .toList();

    return Poll(
      questions: questionsList,
      questionType: QuestionTypeExtension.fromString(json['questionType']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questions': questions.map((question) => question.toJson()).toList(),
      'questionType': questionType.name,
    };
  }
}
