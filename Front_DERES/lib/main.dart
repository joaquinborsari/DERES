import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:topicos/admin/bloc/admin_bloc.dart';
import 'package:topicos/admin/bloc/admin_event.dart';
import 'package:topicos/admin/view/admin_edit_poll.dart';
import 'package:topicos/admin/view/admin_page.dart';
import 'package:topicos/company/bloc/company_bloc.dart';
import 'package:topicos/company/bloc/company_event.dart';
import 'package:topicos/company/view/company_page.dart';
import 'package:topicos/company/view/company_poll.dart';
import 'package:topicos/home/view/home_page.dart';
import 'package:topicos/login/login.dart';
import 'package:topicos/sign_in/view/sign_in_route.dart';
import 'package:topicos/supplier/view/view.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: HomePage.path,
  routes: [
    GoRoute(
      path: SignInPage.path,
      pageBuilder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: LoginPage.path,
      pageBuilder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: HomePage.path,
      pageBuilder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: SupplierPage.path,
      pageBuilder: (context, state) => const SupplierPage(),
    ),
    ShellRoute(
        builder: (context, state, child) {
          return BlocProvider<CompanyBloc>(
            create: (ctx) =>
                CompanyBloc()..add(const CompanyQuestionRequested()),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: CompanyPage.path,
            pageBuilder: (context, state) => const CompanyPage(),
          ),
          GoRoute(
            path: CompanyPollPage.path,
            pageBuilder: (context, state) {
              return const CompanyPollPage();
            },
          ),
        ]),
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider<AdminBloc>(
          create: (ctx) => AdminBloc()..add(const AdminQuestionRequested()),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: AdminPage.path,
          name: AdminPage.path,
          pageBuilder: (context, state) => const AdminPage(),
        ),
        GoRoute(
          path: AdminPollPage.path,
          name: AdminPollPage.path,
          pageBuilder: (context, state) => const AdminPollPage(),
        ),
      ],
    )
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
