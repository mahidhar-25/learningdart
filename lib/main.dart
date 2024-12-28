import 'package:flutter/material.dart';
import 'package:learningdart/auth/login_view.dart';
import 'package:learningdart/auth/register_view.dart';
import 'package:learningdart/components/home_page.dart';
import 'package:logger/logger.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

final logger = Logger();

// Entry point of the app
void main() async {
  // Ensures that the widgets are initialized properly
  WidgetsFlutterBinding.ensureInitialized();

  // You can add any async initialization here (e.g., initializing databases, etc.)

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Wrapping the entire app with KeyboardAvoider widget to ensure that the keyboard
      // does not obscure the input fields on the screen.
      home: KeyboardAvoider(
        child: const HomePage(),
      ),
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
      },
      // You can handle unknown routes here if needed
      onUnknownRoute: (settings) {
        logger.e("Unknown route: ${settings.name}");
        return MaterialPageRoute(builder: (context) => const HomePage());
      },
    );
  }
}
