import 'package:flutter/material.dart';
import 'package:topicos/admin/view/admin_view.dart';

class AdminPage extends Page<void> {
  const AdminPage({super.key});

  static const path = '/admin';

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      settings: this,
      builder: (context) {
        return const AdminView();
      },
    );
  }
}
