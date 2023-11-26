import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class HomeState extends Equatable {
  const HomeState();

  const HomeState.initial() : this();

  @override
  List<Object?> get props => [];

  HomeState copyWith() {
    return const HomeState();
  }
}
