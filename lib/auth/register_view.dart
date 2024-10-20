import 'package:flutter/material.dart';
import 'package:learningdart/components/custom_hoverbutton.dart';
import 'package:learningdart/components/custom_textfield.dart';
import 'package:learningdart/database/local_db.dart';
import '../components/logger_component.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(Colors.blue.shade300.value),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CustomTextField(
            labelText: 'Username',
            controller: _email,
            hintText: 'Enter your username',
          ),
          CustomTextField(
            labelText: 'Password',
            controller: _password,
            hintText: 'Enter your password',
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          HoverButton(
              label: 'Register',
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                logger.i('$email, $password');
                final Map<String, dynamic> registered =
                    await LocalDatabaseAuthentication()
                        .insertNewUser(email, password);
                if (registered['success']) {
                  setState(() {
                    _email.text = '';
                    _password.text = '';
                  });
                  Navigator.pushNamed(context, '/login');
                } else if (registered['message'] == 'User already exists') {
                  logger.e('User already exists');
                } else {
                  logger.e(registered['message']);
                }
              },
              width: MediaQuery.of(context).size.width *
                  0.7, // Example: control button width
              alignment: Alignment.center, // Example: control button position
              padding: const EdgeInsets.symmetric(
                horizontal: 0, // No horizontal padding
                vertical: 15, // Increase vertical padding
              ))
        ],
      ),
    );
  }
}
