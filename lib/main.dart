import 'package:flutter/material.dart';
import 'package:learningdart/auth/login_view.dart';
import 'package:learningdart/auth/register_view.dart';
import 'package:logger/logger.dart';

final logger = Logger();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const RegisterView(),
    routes: {
      '/login': (context) => const LoginView(),
      '/register': (context) => const RegisterView(),
    },
  ));
}
