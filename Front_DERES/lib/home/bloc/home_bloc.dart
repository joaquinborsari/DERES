import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topicos/home/bloc/home_event.dart';
import 'package:topicos/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState.initial());
}
