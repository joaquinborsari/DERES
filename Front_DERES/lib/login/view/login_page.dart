import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topicos/login/bloc/login_bloc.dart';
import 'package:topicos/login/view/login_view.dart';

class LoginPage extends Page<void> {
  const LoginPage({super.key});

  static const path = '/login';

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      settings: this,
      builder: (context) {
        return BlocProvider<LoginBloc>(
          create: (_) {
            return LoginBloc();
          },
          child: const LoginView(),
        );
      },
    );
  }
}
