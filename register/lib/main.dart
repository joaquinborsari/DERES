import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:register/sign_in/sign_in.dart';
import 'package:register/sign_in/view/provider_view.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: SignInPage.path,
  routes: [
    ShellRoute(
        builder: (context, state, child) {
          return BlocProvider<SignInBloc>(
            create: (ctx) => SignInBloc(),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: SignInPage.path,
            pageBuilder: (context, state) => const SignInPage(),
          ),
          GoRoute(
            path: ProviderPage.path,
            pageBuilder: (context, state) => const ProviderPage(),
          ),
        ])
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        appBarTheme: const AppBarTheme(color: Colors.orange),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.orangeAccent,
        ),
      ),
      routerConfig: _router,
    );
  }
}
