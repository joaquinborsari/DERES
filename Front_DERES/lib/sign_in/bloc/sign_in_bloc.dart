import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:topicos/extensions/api.dart';
import 'package:topicos/extensions/privilege.dart';
import 'package:topicos/form_inputs/lib/form_inputs.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc()
      :
        //_authenticationClient = authenticationClient,
        super(const SignInState.initial()) {
    on<SignInEmailChanged>(_onEmailChanged);
    on<SignInPasswordChanged>(_onPasswordChanged);
    on<SignInConfirmationPasswordChanged>(_onConfirmationPasswordChanged);
    on<SignInPasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<SignInWithEmailAndPasswordRequested>(
      _onSignInWithEmailAndPasswordRequested,
    );
    on<SignInPrivilageChanged>(_onSignInPrivilageChanged);
  }

  //final AuthenticationClient _authenticationClient;

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
      var client = http.Client();
      var data = await client.fetchData(
        url: 'http://localhost:8080/users/signup',
        headers: {
          "user_name": state.email.value,
          "password": state.password.value,
          "privilege": state.privilege.name,
        },
      );
      if (data.containsKey('privilage')) {
        String privilage = data['privilage'];
        if (privilage == 'admin') {
          emit(state.copyWith(privilege: Privilege.admin));
        } else if (privilage == 'user') {
          emit(state.copyWith(privilege: Privilege.user));
        } else if (privilage == 'provider') {
          emit(state.copyWith(privilege: Privilege.provider));
        } else {
          emit(state.copyWith(privilege: Privilege.all));
        }
      }

      emit(state.copyWith(status: FormzSubmissionStatus.success));
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
