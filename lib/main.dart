import 'package:flutter/material.dart';
import 'package:learningdart/components/custom_hoverbutton.dart';
import 'package:learningdart/components/custom_textfield.dart';
import 'package:logger/logger.dart';
import 'package:learningdart/database/local_db.dart';

final logger = Logger();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          ),
          HoverButton(
              label: 'Register',
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                logger.i('$email, $password');
                await LocalDatabaseAuthentication()
                    .insertNewUser(email, password);
                setState(() {
                  _email.text = '';
                  _password.text = '';
                });
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
