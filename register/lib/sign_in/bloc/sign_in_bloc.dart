import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    on<SignInUserNameChanged>(_onUserNameChanged);
    on<SignInDataChanged>(_onSignInDataChanged);
    on<SignInPhoneChanged>(_onSignInPhoneChanged);
    on<SignInAddressChanged>(_onSignInAddressChanged);
    on<SignInContactsChanged>(_onSignInContactsChanged);
    on<SignInRutChanged>(_onSignInRutChanged);
    on<SignInTypeChanged>(_onSignInTypeChanged);
    on<SignInPhonehanged>(_onSignInPhonehanged);
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
      if (state.privilege == Privilege.user) {
        final body = jsonEncode({
          "user_name": state.email.value,
          "password": state.password.value,
          "privilege": state.privilege.name.toUpperCase(),
          "email": state.email.value,
        });

        try {
          final response = await http.post(
            url,
            body: body,
            headers: {'Content-Type': 'application/json'},
          );

          if (response.statusCode == 202) {
            emit(state.copyWith(status: FormzSubmissionStatus.success));
          } else {
            emit(state.copyWith(status: FormzSubmissionStatus.failure));
          }
        } catch (e) {
          emit(state.copyWith(status: FormzSubmissionStatus.failure));
        }
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

  FutureOr<void> _onUserNameChanged(
      SignInUserNameChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(username: event.username));
  }

  FutureOr<void> _onSignInDataChanged(
      SignInDataChanged event, Emitter<SignInState> emit) async {
    final url = Uri.parse('http://172.178.74.246:8080/addProvider');
    try {
      final body = jsonEncode({
        "name": state.username,
        "email": state.email.value,
        "address": state.address,
        "phone": state.phone,
        "contact": state.phone,
        "rut": state.rut,
        "type": state.type,
      });

      final response = await http.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final providerId = data['provider_id'];
        final url = Uri.parse('http://172.178.74.246:8080/signup');
        final body = jsonEncode({
          "name": state.email.value,
          "password": state.password.value,
          "privilege": state.privilege.name.toUpperCase(),
          "provider_id": providerId,
          "email": state.email.value,
        });
        final response2 = await http.post(
          url,
          body: body,
          headers: {'Content-Type': 'application/json'},
        );
        if (response2.statusCode == 201) {
          emit(state.copyWith(status: FormzSubmissionStatus.success));
        }
      } else {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  FutureOr<void> _onSignInPhoneChanged(
      SignInPhoneChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(phone: event.phone));
  }

  FutureOr<void> _onSignInAddressChanged(
      SignInAddressChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(address: event.address));
  }

  FutureOr<void> _onSignInContactsChanged(
      SignInContactsChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(contact: event.contact));
  }

  FutureOr<void> _onSignInRutChanged(
      SignInRutChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(rut: event.rut));
  }

  FutureOr<void> _onSignInTypeChanged(
      SignInTypeChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(type: event.type));
  }

  FutureOr<void> _onSignInPhonehanged(
      SignInPhonehanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(phone: event.phone));
  }
}
