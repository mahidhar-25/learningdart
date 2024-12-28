// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learningdart/components/custom_textfield.dart';
import 'package:learningdart/components/khatabook/accounts_db.dart';
import 'package:learningdart/components/khatabook/users_db.dart';
import 'package:learningdart/components/logger_component.dart';
import 'package:learningdart/components/model/khatabook_account.dart';
import 'package:learningdart/components/model/khatabook_receivables.dart';
import 'package:learningdart/components/resizable_textarea.dart';
import 'package:learningdart/database/db_manager.dart';
import 'package:learningdart/helpers/finance_calculations.dart';

class AmountRecievingPage extends StatefulWidget {
  const AmountRecievingPage({super.key});

  @override
  State<AmountRecievingPage> createState() => _AmountRecievingPageState();
}

class _AmountRecievingPageState extends State<AmountRecievingPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  List<Map<String, dynamic>> _accountDetails = [];
  Map<String, dynamic>? _selectedUser;
  Map<String, dynamic>? _selectedAccount;
  bool _isDropdownOpen = false;

  late final TextEditingController _amount;
  late final TextEditingController _interestRate;
  late final TextEditingController _compoundedTime;
  late final FocusNode _compoundedFocus;
  late final FocusNode _amountFocus;
  late final FocusNode _interestRateFocus;

  late final TextEditingController _creationNotes;
  late final FocusNode _creationNotesFocus;

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
    final List<Map<String, dynamic>> usersFromDb =
        await KhatabookUser().getAllUsers();
    setState(() {
      _users = usersFromDb;
      _filteredUsers = _users;
    });
  }

  Future<void> _fetchAccountDetails() async {
    if (_selectedUser != null) {
      // Fetch account details for the selected user
      final List<Map<String, dynamic>> accountDetailsFromDb =
          await KhatabookAccount()
              .getAllActiveaccountsofUser(_selectedUser!['id']);

      final List<Map<String, dynamic>> mutableUserInfo = accountDetailsFromDb
          .where((account) =>
              account['status'] == 'active') // Filter active accounts
          .map((account) =>
              Map<String, dynamic>.from(account)) // Create a mutable copy
          .toList();

      for (var account in mutableUserInfo) {
        DateTime startDate = DateTime.parse(account['start_date']);
        DateTime endDate = account['end_date'] != null
            ? DateTime.parse(account['end_date'])
            : DateTime.now();

        // Check if 'principal_amount' and 'interest_rate' are already double
        double principalAmount = account['principal_amount'] is String
            ? double.parse(account['principal_amount'])
            : account['principal_amount'];

        double interestRate = account['interest_rate'] is String
            ? double.parse(account['interest_rate'])
            : account['interest_rate'];

        Map<String, dynamic> result;
        if (account['is_compounded'] == 1) {
          int compoundedMonths = account['compounded_months'] is String
              ? int.parse(account['compounded_months'])
              : account['compounded_months'];
          result = calculateCompoundInterest(principalAmount, interestRate,
              compoundedMonths, startDate, endDate);
          account['compounding_details'] = result['compoundingDetails'];
          account['total_time'] = result['totalTime'];
        } else {
          result = calculateSimpleInterest(
              principalAmount, interestRate, startDate, endDate);
          account['total_time'] = result['timeDifference']['totalTime'];
        }

        account['interest_amount'] = result['interestAmount'];

        account['total_amount'] = result['totalAmount'];
      }

      setState(() {
        _accountDetails = mutableUserInfo;
      });
    }
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

  void _clearSelectedAccount() {
    setState(() {
      _selectedAccount = null;
    });
  }

  String? _selectedOption = 'No';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amount Receiving'),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isDropdownOpen = false;
          });
          FocusScope.of(context).unfocus();
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
                  FocusScope.of(context).unfocus();
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
                        .take(5)
                        .map((user) => ListTile(
                              title: Text(user['name']),
                              onTap: () async {
                                setState(() {
                                  _selectedUser = user;

                                  _searchController.text = user['name'];
                                  _isDropdownOpen = false;
                                  _selectedAccount = null;
                                });

                                FocusScope.of(context).unfocus();
                                await _fetchAccountDetails();
                              },
                            ))
                        .toList(),
                  ),
                ),
              const SizedBox(height: 20),
              if (_accountDetails.isNotEmpty)
                const Text(
                  'Account Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 10),
              if (_selectedAccount != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: _clearSelectedAccount,
                    child: const Text("Show All Accounts"),
                  ),
                ),
              if (_selectedAccount != null)
                // Display selected account's details only
                _buildAccountCard(_selectedAccount!, isExpanded: true)
              else
                // Show all accounts with ability to select one
                Column(
                  children: _accountDetails.map((account) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAccount = account;
                        });
                      },
                      child: _buildAccountCard(account),
                    );
                  }).toList(),
                ),
              if (_selectedAccount != null)
                Column(children: [
                  CustomTextField(
                    labelText: 'Amount',
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    focusNode: _amountFocus, // Only focuses when user taps
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context, isStartDate: false),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        enabled: true,
                        labelText: 'End Date',
                        controller: TextEditingController(
                            text: _endDate == null
                                ? ''
                                : DateFormat('yyyy-MM-dd').format(_endDate!)),
                        keyboardType: TextInputType.none,
                      ),
                    ),
                  ),
                  ResizableTextField(
                    controller: _creationNotes,
                    hintText: 'Enter your text here...',
                    focusNode: _creationNotesFocus,
                    labelText: 'Account closing Notes', // Custom label text
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      /*
                      final db = DatabaseManager();
                      final schema = await db.query("SELECT * FROM Accounts;");

                      for (var row in schema) {
                        logger.i(row);
                      }
                      */
                      if (_selectedAccount != null && _selectedUser != null) {
                        logger.i(
                            'Selected Account ID: ${_selectedAccount?['account_id']}, '
                            'Selected User ID: ${_selectedAccount?['user_id']}, '
                            'Amount: ${_amount.text}, '
                            'End Date: ${_endDate.toString()},\n '
                            'Creation Notes: ${_creationNotes.text}');

                        KhatabookReceivablesClass account =
                            KhatabookReceivablesClass(
                          userId: _selectedAccount?['user_id'],
                          accountId: _selectedAccount?['account_id'],
                          amountReceived: double.parse(_amount.text),
                          endDate: _endDate!,
                          receivedNotes: _creationNotes.text,
                          status: 'completed',
                        );
                        logger.i(account.toString());
                        int response = await KhatabookAccount()
                            .updateStatusByIdInKhatabookAccount(account);

                        if (response > 0) {
                          logger.i(
                              'Created New Account Successfull with ID: $response');
                          const SnackBar(
                              content: Text('Created New Account Successfull'));
                        } else {
                          const SnackBar(
                              content: Text('Failed to create account '));
                        }

                        if (_selectedAccount!['total_amount'] >
                            double.parse(_amount.text)) {
                          double remaingAmount =
                              _selectedAccount!['total_amount'] -
                                  double.parse(_amount.text);
                          KhatabookAccountClass account = KhatabookAccountClass(
                            userId: _selectedAccount?['user_id'],
                            principalAmount: remaingAmount,
                            interestRate: _selectedAccount!['interest_rate'],
                            startDate: _endDate!,
                            isCompounded:
                                _selectedAccount!['is_compounded'] == 1,
                            compoundedMonths:
                                _selectedAccount!['compounded_months'],
                            accountNotes:
                                '${_creationNotes.text} created new account for balence amount',
                            status: 'active',
                          );

                          logger.i(account.toString());
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
                        Navigator.pop(context);
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
                      'Update Account',
                      style: TextStyle(
                        fontSize: 16, // Optional: Adjust text size
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ])
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard(Map<String, dynamic> account,
      {bool isExpanded = false}) {
    return Card(
      color: _selectedAccount == account
          ? const Color.fromARGB(255, 255, 255, 255)
          : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Date and Total Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Start Date: ${account['start_date']}",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    overflow:
                        TextOverflow.ellipsis, // Ensure it doesn't overflow
                    maxLines: 1, // Limit to one line before ellipsis appears
                  ),
                ),
                const SizedBox(width: 8), // Add some space between items
                Flexible(
                  child: Text(
                    "Time: ${account['total_time']}",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    overflow:
                        TextOverflow.ellipsis, // Ensure it doesn't overflow
                    maxLines: 2, // Limit to one line before ellipsis appears
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            const Divider(thickness: 1.5, color: Colors.grey),
            const SizedBox(height: 8.0),
            // Show Principal, Interest, Total only if expanded
            if (isExpanded || true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Principal Amount
                  Column(
                    children: [
                      const Text(
                        "Principal",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        account['principal_amount']
                            .toStringAsFixed(3)
                            .toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  // Interest Amount
                  Column(
                    children: [
                      const Text(
                        "Interest",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        account['interest_amount']
                            .toStringAsFixed(3)
                            .toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  // Total Amount
                  Column(
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        account['total_amount'].toStringAsFixed(3).toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
