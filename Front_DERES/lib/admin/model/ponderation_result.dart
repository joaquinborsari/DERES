import 'package:topicos/admin/bloc/admin_state.dart';

class PonderationResult {
  final Map<QuestionType, int> typePonderationSum;
  final bool isValid;

  PonderationResult({required this.typePonderationSum, this.isValid = true});
}
