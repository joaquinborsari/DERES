import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topicos/extensions/privilege.dart';
import 'package:topicos/form_inputs/lib/form_inputs.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState.initial()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<LoginWithEmailAndPasswordRequested>(
      _onLoginWithEmailAndPasswordRequested,
    );
  }

  bool get valid => Formz.validate([state.email, state.password]);

  bool get obscurePassowrd => state.obscurePassword;

  FutureOr<void> _onLoginWithEmailAndPasswordRequested(
    LoginWithEmailAndPasswordRequested event,
    Emitter<LoginState> emit,
  ) async {
    final url = Uri.parse('http://172.178.74.246:8080/login');

    final body = jsonEncode(
        {'name': state.email.value, 'password': state.password.value});

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
              loginStatus: LoginStatus.success, privilege: Privilege.user));
        } else if (privilege == 'ADMIN') {
          emit(state.copyWith(
              loginStatus: LoginStatus.success, privilege: Privilege.admin));
        } else if (privilege == 'PROVIDER') {
          final provider = jsonDecode(response.body)['provider_id'];
          if (provider != null) {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setString('providerId', provider);
          }

          emit(state.copyWith(
              loginStatus: LoginStatus.success, privilege: Privilege.provider));
        }
      } else {
        print('Failed to log in');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  FutureOr<void> _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(email: Email.dirty(event.email)));
  }

  FutureOr<void> _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(password: Password.dirty(event.password)));
  }

  FutureOr<void> _onPasswordVisibilityChanged(
    LoginPasswordVisibilityChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(obscurePassword: event.obscure));
  }
}
