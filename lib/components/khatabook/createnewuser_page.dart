// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:learningdart/components/custom_textfield.dart';
import 'package:learningdart/components/khatabook/users_db.dart';
import 'package:learningdart/components/model/khatabook_user.dart';

class CreatenewuserPage extends StatefulWidget {
  const CreatenewuserPage({super.key});

  @override
  State<CreatenewuserPage> createState() => _CreatenewuserPageState();
}

class _CreatenewuserPageState extends State<CreatenewuserPage> {
  late final TextEditingController _name;
  late final TextEditingController _village;
  late final TextEditingController _address;
  late final TextEditingController _phoneNumber;
  late final FocusNode _nameFocus;
  late final FocusNode _villageFocus;
  late final FocusNode _addressFocus;
  late final FocusNode _phoneNumberFocus;

  @override
  void initState() {
    _name = TextEditingController();
    _village = TextEditingController();
    _address = TextEditingController();
    _phoneNumber = TextEditingController();
    _nameFocus = FocusNode();
    _villageFocus = FocusNode();
    _addressFocus = FocusNode();
    _phoneNumberFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _village.dispose();
    _address.dispose();
    _phoneNumber.dispose();
    _nameFocus.dispose();
    _villageFocus.dispose();
    _addressFocus.dispose();
    _phoneNumberFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create New User'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            CustomTextField(
              labelText: 'Name',
              controller: _name,
              keyboardType: TextInputType.text,
              focusNode: _nameFocus, // Only focuses when user taps
            ),
            CustomTextField(
              labelText: 'Village',
              controller: _village,
              keyboardType: TextInputType.text,
              focusNode: _villageFocus, // Same behavior for interest rate field
            ),
            CustomTextField(
              labelText: 'Phone Number',
              controller: _phoneNumber,
              keyboardType: TextInputType.number,
              focusNode: _phoneNumberFocus, // Only focuses when user taps
            ),
            CustomTextField(
              labelText: 'Address',
              controller: _address,
              keyboardType: TextInputType.text,
              focusNode: _addressFocus, // Same behavior for interest rate field
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                KhatabookUserClass user = KhatabookUserClass(
                    name: _name.text,
                    village: _village.text,
                    phone_number: _phoneNumber.text,
                    address: _address.text);
                Map<String, dynamic> result =
                    await KhatabookUser().insertNewKhatabookUser(user);
                if (result['success']) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Created New User Successfull')),
                  );
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pop(context); // Go back to the previous screen
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Creating New User UnSuccessfull')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 62, 165, 177), // Set your desired background color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Slightly rounded corners
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // Adjust padding
              ),
              child: const Text(
                'Add New User',
                style: TextStyle(
                  fontSize: 16, // Optional: Adjust text size
                  color: Colors.white, // Text color
                ),
              ),
            ),
          ]),
        ));
  }
}
