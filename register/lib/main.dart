import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:register/sign_in/view/sign_in_route.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: SignInPage.path,
  routes: [
    GoRoute(
      path: SignInPage.path,
      pageBuilder: (context, state) => const SignInPage(),
    ),
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
