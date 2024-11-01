// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learningdart/components/custom_textfield.dart';
import 'package:learningdart/components/khatabook/accounts_db.dart';
import 'package:learningdart/components/khatabook/users_db.dart';
import 'package:learningdart/components/logger_component.dart';
import 'package:learningdart/components/model/khatabook_account.dart';

class AmountGivingPage extends StatefulWidget {
  const AmountGivingPage({super.key});

  @override
  State<AmountGivingPage> createState() => _AmountGivingPageState();
}

class _AmountGivingPageState extends State<AmountGivingPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  Map<String, dynamic>? _selectedUser;
  bool _isDropdownOpen = false;

  late final TextEditingController _amount;
  late final TextEditingController _interestRate;
  late final TextEditingController _compoundedTime;
  late final FocusNode _compoundedFocus;
  late final FocusNode _amountFocus;
  late final FocusNode _interestRateFocus;

  late final TextEditingController _creationNotes;
  late final FocusNode _creationNotesFocus;
  bool _isCompoundedEnabled = false;
  @override
  void initState() {
    _amount = TextEditingController();
    _interestRate = TextEditingController();
    _compoundedTime = TextEditingController();
    _compoundedFocus = FocusNode();
    _amountFocus = FocusNode();
    _interestRateFocus = FocusNode();
    _creationNotes = TextEditingController();
    _creationNotesFocus = FocusNode();
    super.initState();
    _fetchUsers();
  }

  @override
  void dispose() {
    _amount.dispose();
    _interestRate.dispose();
    _compoundedTime.dispose();
    _compoundedFocus.dispose();
    _amountFocus.dispose();
    _interestRateFocus.dispose();
    _creationNotes.dispose();
    _creationNotesFocus.dispose();

    super.dispose();
  }

  // Variables for the start and end dates
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      if (!mounted) return;
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _fetchUsers() async {
    // Fetch users from database
    final List<Map<String, dynamic>> usersFromDb =
        await KhatabookUser().getAllUsers();
    setState(() {
      _users = usersFromDb;
      _filteredUsers = _users; // Initially, filtered list is the full list
    });
  }

  void _filterUsers(String searchTerm) {
    setState(() {
      _filteredUsers = _users
          .where((user) => user['name']
              .toString()
              .toLowerCase()
              .contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amount Giving'),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isDropdownOpen = false; // Close the dropdown on outside tap
          });
          FocusScope.of(context).unfocus(); // Remove focus from TextField
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select User',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isDropdownOpen = !_isDropdownOpen;
                  });
                  FocusScope.of(context)
                      .unfocus(); // Remove focus from TextField
                },
                child: SizedBox(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      _filterUsers(value);
                      setState(() {
                        _isDropdownOpen = true;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Select or Search User',
                      suffixIcon: Icon(
                        _isDropdownOpen
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              if (_isDropdownOpen && _filteredUsers.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: _filteredUsers
                        .take(5) // Limit the number of options shown to 5
                        .map((user) => ListTile(
                              title: Text(user['name']),
                              onTap: () {
                                setState(() {
                                  _selectedUser = user;
                                  _searchController.text = user['name'];
                                  _isDropdownOpen = false;
                                });
                                FocusScope.of(context).unfocus();
                              },
                            ))
                        .toList(),
                  ),
                ),
/*

keyboardType: TextInputType.multiline,
          maxLines: null, // Allows the TextField to be multiline
          minLines: 5, // Sets a minimum height for the TextField
          decoration: InputDecoration(
            hintText: 'Enter your text here...',
            border: OutlineInputBorder(),
          ),
 */
              const SizedBox(height: 5),
              _selectedUser != null
                  ? Column(children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Amount Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                      CustomTextField(
                        labelText: 'Amount',
                        controller: _amount,
                        keyboardType: TextInputType.number,
                        focusNode: _amountFocus, // Only focuses when user taps
                      ),
                      CustomTextField(
                        labelText: 'Interest Rate(%)',
                        controller: _interestRate,
                        keyboardType: TextInputType.number,
                        focusNode:
                            _interestRateFocus, // Same behavior for interest rate field
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context, isStartDate: true),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            labelText: 'Start Date',
                            controller: TextEditingController(
                                text: _startDate == null
                                    ? ''
                                    : DateFormat('yyyy-MM-dd')
                                        .format(_startDate!)),
                            keyboardType: TextInputType.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context, isStartDate: false),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            enabled: false,
                            labelText: 'End Date',
                            controller: TextEditingController(
                                text: _endDate == null
                                    ? ''
                                    : DateFormat('yyyy-MM-dd')
                                        .format(_endDate!)),
                            keyboardType: TextInputType.none,
                          ),
                        ),
                      ),
                      CustomTextField(
                        labelText: 'Account Creation Notes',
                        controller: _creationNotes,
                        keyboardType: TextInputType.multiline,
                        focusNode: _creationNotesFocus,
                        maxLines: null,
                        minLines: 5,
                        hintText: 'Enter your text here...',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Enable Compounded Time',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 20),
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: _isCompoundedEnabled,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isCompoundedEnabled = value;
                                    });
                                  },
                                ),
                              ),
                            ]),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: _isCompoundedEnabled
                            ? CustomTextField(
                                labelText: 'Compounded Time (in M)',
                                controller: _compoundedTime,
                                keyboardType: TextInputType.number,
                                focusNode: _compoundedFocus,
                              )
                            : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_selectedUser != null) {
                            KhatabookAccountClass account =
                                KhatabookAccountClass(
                              userId: _selectedUser!['id'],
                              principalAmount: double.parse(_amount.text),
                              interestRate: double.parse(_interestRate.text),
                              startDate: _startDate!,
                              isCompounded: _isCompoundedEnabled,
                              compoundedMonths: _isCompoundedEnabled
                                  ? int.parse(_compoundedTime.text)
                                  : 0,
                              accountNotes: _creationNotes.text,
                              status: 'active',
                            );

                            Map<String, dynamic> response =
                                await KhatabookAccount()
                                    .insertNewKhatabookAccount(account);

                            if (response['success']) {
                              logger.i(
                                  'Created New Account Successfull with ID: $response');

                              const SnackBar(
                                  content:
                                      Text('Created New Account Successfull'));
                              Navigator.pop(context);
                            } else {
                              logger.e(
                                  'Error Creating New Account: ${response['message']}');
                              const SnackBar(
                                  content: Text('Failed to create account '));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 62, 165,
                              177), // Set your desired background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Slightly rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12), // Adjust padding
                        ),
                        child: const Text(
                          'Add Account',
                          style: TextStyle(
                            fontSize: 16, // Optional: Adjust text size
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ])
                  : Container(),

              // Additional widgets can be added below
            ],
          ),
        ),
      ),
    );
  }
}
