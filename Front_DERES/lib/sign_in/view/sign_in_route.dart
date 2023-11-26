import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topicos/sign_in/sign_in.dart';

class SignInPage extends Page<void> {
  const SignInPage();

  static const path = '/sign-in';

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) {
        return BlocProvider(
          create: (_) => SignInBloc(
              //authenticationClient: context.read<AuthenticationClient>(),
              ),
          child: const SignInView(),
        );
      },
    );
  }
}
