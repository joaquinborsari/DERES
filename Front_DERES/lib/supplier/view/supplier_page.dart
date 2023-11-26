import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topicos/supplier/bloc/supplier_bloc.dart';
import 'package:topicos/supplier/bloc/supplier_event.dart';
import 'package:topicos/supplier/view/view.dart';

class SupplierPage extends Page<void> {
  const SupplierPage({super.key});
  static const path = '/supplier';
  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      settings: this,
      builder: (context) {
        return BlocProvider<SupplierBloc>(
          create: (_) {
            return SupplierBloc()..add(const SupplierRequested());
          },
          child: const SupplierView(),
        );
      },
    );
  }
}
