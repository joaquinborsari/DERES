import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topicos/home/bloc/home_bloc.dart';
import 'package:topicos/home/view/home_view.dart';

class HomePage extends Page<void> {
  const HomePage({super.key});

  static const path = '/home';

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      settings: this,
      builder: (context) {
        return BlocProvider<HomeBloc>(
          create: (_) {
            return HomeBloc();
          },
          child: const HomeView(),
        );
      },
    );
  }
}
