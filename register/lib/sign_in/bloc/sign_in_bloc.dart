import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:register/form_inputs/lib/form_inputs.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(const SignInState.initial()) {
    on<SignInEmailChanged>(_onEmailChanged);
    on<SignInPasswordChanged>(_onPasswordChanged);
    on<SignInConfirmationPasswordChanged>(_onConfirmationPasswordChanged);
    on<SignInPasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<SignInWithEmailAndPasswordRequested>(
      _onSignInWithEmailAndPasswordRequested,
    );
    on<SignInPrivilageChanged>(_onSignInPrivilageChanged);
  }

  bool get valid =>
      Formz.validate([state.email, state.password]) &&
      state.password.value == state.confirmationPassword;

  bool get emailIsValid {
    final email = state.email;
    return email.isPure || email.isValid;
  }

  bool get passwordIsValid {
    final password = state.password;
    return password.isPure || password.isValid;
  }

  bool get passwordsMatch {
    final password = state.password;
    return password.isPure || password.value == state.confirmationPassword;
  }

  bool get obscurePassowrds => state.obscurePasswords;

  FutureOr<void> _onSignInWithEmailAndPasswordRequested(
    SignInWithEmailAndPasswordRequested event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final url = Uri.parse('http://172.178.74.246:8080/signup');

      final body = jsonEncode({
        "user_name": state.email.value,
        "password": state.password.value,
        "privilege": state.privilege.name,
      });

      try {
        final response = await http.post(
          url,
          body: body,
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 202) {
          final privilege = jsonDecode(response.body)['privilege'];
          if (privilege == 'USER') {
            emit(state.copyWith(
                status: FormzSubmissionStatus.success,
                privilege: Privilege.user));
          } else if (privilege == 'ADMIN') {
            emit(state.copyWith(
                status: FormzSubmissionStatus.success,
                privilege: Privilege.admin));
          } else if (privilege == 'PROVIDER') {
            emit(state.copyWith(
                status: FormzSubmissionStatus.success,
                privilege: Privilege.provider));
          }
        } else {
          emit(state.copyWith(status: FormzSubmissionStatus.failure));
        }
      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    } on Exception {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  FutureOr<void> _onEmailChanged(
    SignInEmailChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(email: Email.dirty(event.email)));
  }

  FutureOr<void> _onPasswordChanged(
    SignInPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(password: Password.dirty(event.password)));
  }

  FutureOr<void> _onPasswordVisibilityChanged(
    SignInPasswordVisibilityChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(obscurePasswords: event.obscure));
  }

  FutureOr<void> _onConfirmationPasswordChanged(
    SignInConfirmationPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(confirmationPassword: event.password));
  }

  FutureOr<void> _onSignInPrivilageChanged(
      SignInPrivilageChanged event, Emitter<SignInState> emit) {
    emit((state.copyWith(privilege: event.privilage)));
  }
}
