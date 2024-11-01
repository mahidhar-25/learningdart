import 'package:flutter/material.dart';
import 'package:learningdart/components/khatabook/accounts_db.dart';
import 'package:learningdart/components/khatabook/transaction_db.dart';
import 'package:learningdart/components/logger_component.dart';

class TransactionDetailViewPage extends StatefulWidget {
  const TransactionDetailViewPage({super.key});

  @override
  State<TransactionDetailViewPage> createState() =>
      _TransactionDetailViewPageState();
}

class _TransactionDetailViewPageState extends State<TransactionDetailViewPage>
    with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> userInfo;
  List<Map<String, dynamic>> filteredAccounts = [];
  bool isLoading = true;
  String selectedTab = 'credit';
  DateTime? selectedDateFilter;
  String? selectedSortBy = 'transaction_date';
  DateTime? fromDate;
  DateTime? toDate;

  Future<void> _pickDate(BuildContext context,
      {required bool isFromDate}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          fromDate = pickedDate;
        } else {
          toDate = pickedDate;
        }
        filteredAccounts = _filterAndSortAccounts();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserInfo(); // Fetch data from the database on widget load
  }

  Future<void> _fetchUserInfo() async {
    final List<Map<String, dynamic>>? userInfoFromDb =
        await KhatabookTransaction().getAllTransactions();
    setState(() {
      userInfo = userInfoFromDb!;
      filteredAccounts = _filterAndSortAccounts(); // Initial filter and sort
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> _filterAndSortAccounts() {
    List<Map<String, dynamic>> filtered = userInfo
        .where((account) => account['transaction_type'] == selectedTab)
        .toList();

    // Apply date filter if selected
    if (fromDate != null) {
      filtered = filtered.where((account) {
        final startDate = DateTime.parse(account['transaction_date']);
        if (toDate != null) {
          return startDate.isAfter(fromDate!) && startDate.isBefore(toDate!);
        }
        return startDate.isAfter(fromDate!);
      }).toList();
    }

    if (toDate != null) {
      filtered = filtered.where((account) {
        final startDate = DateTime.parse(account['transaction_date']);
        return startDate.isBefore(toDate!);
      }).toList();
    }

    // Helper function to safely parse double values
    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0; // Default to 0.0 if value is null or not a valid number
    }

// Define a map with sorting functions based on the selectedSortBy value
    final sortingOptions = {
      'transaction_date': (a, b) => DateTime.parse(b['transaction_date'])
          .compareTo(DateTime.parse(a['transaction_date'])),
      'transaction_amount': (a, b) => parseDouble(b['transaction_amount'])
          .compareTo(parseDouble(a['transaction_amount']))
    };

// Check if sorting option is available for the selectedSortBy key
    if (sortingOptions.containsKey(selectedSortBy)) {
      filtered.sort(sortingOptions[selectedSortBy]!);
    }

    return filtered;
  }

  void _onTabChanged(String tab) {
    setState(() {
      selectedTab = tab;
      filteredAccounts = _filterAndSortAccounts();
    });
  }

  void _onSortBySelected(String? sortBy) {
    logger.i("Sort by: $sortBy");
    setState(() {
      selectedSortBy = sortBy;
      filteredAccounts = _filterAndSortAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transactions',
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Tab Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => _onTabChanged('credit'),
                      child: Column(
                        children: [
                          Text(
                            "CREDIT",
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedTab == 'credit'
                                  ? Colors.blue
                                  : Colors.black,
                              fontWeight: selectedTab == 'credit'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (selectedTab == 'credit')
                            Container(
                              margin: const EdgeInsets.only(top: 4.0),
                              height: 2,
                              width: 40,
                              color: Colors.blue,
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onTabChanged('debit'),
                      child: Column(
                        children: [
                          Text(
                            "DEBIT",
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedTab == 'debit'
                                  ? Colors.blue
                                  : Colors.black,
                              fontWeight: selectedTab == 'debit'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (selectedTab == 'debit')
                            Container(
                              margin: const EdgeInsets.only(top: 4.0),
                              height: 2,
                              width: 40,
                              color: Colors.blue,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Filter and Sort Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    // decoration: BoxDecoration(
                    //   color: Colors.grey[200],
                    //   borderRadius: BorderRadius.circular(12),
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.date_range),
                          label: Text(fromDate == null
                              ? "From Date"
                              : "${fromDate!.year}-${fromDate!.month}-${fromDate!.day}"),
                          onPressed: () => {
                            _pickDate(context, isFromDate: true),
                          },
                        ),
                        const Text("To"),
                        TextButton.icon(
                            icon: const Icon(Icons.date_range),
                            label: Text(toDate == null
                                ? "To Date"
                                : "${toDate!.year}-${toDate!.month}-${toDate!.day}"),
                            onPressed: () => {
                                  _pickDate(context, isFromDate: false),
                                }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Sort by dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      // decoration: BoxDecoration(
                      //   color: Colors.grey[200],
                      //   borderRadius: BorderRadius.circular(12),
                      // ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Sort by"),
                        value: selectedSortBy,
                        items: const [
                          DropdownMenuItem(
                              value: 'transaction_amount',
                              child: Text("Transaction Amount")),
                          DropdownMenuItem(
                              value: 'transaction_date',
                              child: Text("Transaction Date")),
                        ],
                        onChanged: _onSortBySelected,
                      )),
                ),
                const SizedBox(height: 8),
                // Account List
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredAccounts.length,
                    itemBuilder: (context, index) {
                      final account = filteredAccounts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 16.0),
                        child: Container(
                          //

                          padding: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row with Date and Amount
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Date: ${account['transaction_date']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Text(
                                    "₹${account['transaction_amount']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: account['transaction_type'] ==
                                              'credit'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // User Information Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${account['name']}, ${account['village']}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    account['transaction_type'] == 'credit'
                                        ? 'Credit'
                                        : 'Debit',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: account['transaction_type'] ==
                                              'credit'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Transaction Notes
                              Text(
                                "Notes: ${account['transaction_notes'] ?? 'N/A'}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Divider(thickness: 0.5, color: Colors.grey[600]),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
