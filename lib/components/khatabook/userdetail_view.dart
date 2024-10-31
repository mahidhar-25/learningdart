import 'package:flutter/material.dart';
import 'package:learningdart/components/khatabook/accounts_db.dart';
import 'package:learningdart/components/logger_component.dart';

class UserDetailViewPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserDetailViewPage({super.key, required this.user});

  @override
  State<UserDetailViewPage> createState() => _UserDetailViewPageState();
}

class _UserDetailViewPageState extends State<UserDetailViewPage>
    with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> userInfo;
  List<Map<String, dynamic>> filteredAccounts = [];
  bool isLoading = true;
  String selectedTab = 'active';
  DateTime? selectedDateFilter;
  String? selectedSortBy = 'start_date';
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
    final List<Map<String, dynamic>> userInfoFromDb =
        await KhatabookAccount().getAllaccountsofUser(widget.user['id']);
    setState(() {
      userInfo = userInfoFromDb;
      filteredAccounts = _filterAndSortAccounts(); // Initial filter and sort
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> _filterAndSortAccounts() {
    List<Map<String, dynamic>> filtered =
        userInfo.where((account) => account['status'] == selectedTab).toList();

    // Apply date filter if selected
    if (fromDate != null) {
      filtered = filtered.where((account) {
        final startDate = DateTime.parse(account['start_date']);
        if (toDate != null) {
          return startDate.isAfter(fromDate!) && startDate.isBefore(toDate!);
        }
        return startDate.isAfter(selectedDateFilter!);
      }).toList();
    }

    if (toDate != null && selectedTab == 'completed') {
      filtered = filtered.where((account) {
        final endDate = DateTime.parse(account['end_date']);
        final startDate = DateTime.parse(account['start_date']);
        return startDate.isBefore(toDate!) && endDate.isBefore(toDate!);
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
      'start_date': (a, b) => DateTime.parse(b['start_date'])
          .compareTo(DateTime.parse(a['start_date'])),
      'end_date': (a, b) => DateTime.parse(b['end_date'])
          .compareTo(DateTime.parse(a['end_date'])),
      'principal_amount': (a, b) => parseDouble(b['principal_amount'])
          .compareTo(parseDouble(a['principal_amount'])),
      'interest_amount': (a, b) => parseDouble(b['interest_rate'])
          .compareTo(parseDouble(a['interest_rate'])),
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
    final user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text("${user['name']}'s Accounts"),
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
                      onTap: () => _onTabChanged('active'),
                      child: Column(
                        children: [
                          Text(
                            "Active",
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedTab == 'active'
                                  ? Colors.blue
                                  : Colors.black,
                              fontWeight: selectedTab == 'active'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (selectedTab == 'active')
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
                      onTap: () => _onTabChanged('completed'),
                      child: Column(
                        children: [
                          Text(
                            "Closed",
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedTab == 'completed'
                                  ? Colors.blue
                                  : Colors.black,
                              fontWeight: selectedTab == 'completed'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (selectedTab == 'completed')
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
                            value: 'principal_amount',
                            child: Text("Principal Amount")),
                        DropdownMenuItem(
                            value: 'interest_rate',
                            child: Text("Interest Rate")),
                        DropdownMenuItem(
                            value: 'start_date', child: Text("StartDate")),
                        DropdownMenuItem(
                            value: 'end_date', child: Text("EndDate")),
                      ],
                      onChanged: _onSortBySelected,
                    ),
                  ),
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
                            vertical: 8.0, horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[400]!),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Account Information
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Start Date: ${account['start_date']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Status: ${account['status']}",
                                    style: TextStyle(
                                      color: account['status'] == 'active'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  "Principal Amount: ₹${account['principal_amount']}"),
                              const SizedBox(height: 4),
                              Text(
                                  "Interest Rate: ${account['interest_rate']}%"),
                              const SizedBox(height: 4),
                              Text(
                                  "Compounded: ${account['is_compounded'] == 1 ? 'Yes' : 'No'}"),
                              if (account['is_compounded'] == 1)
                                Text(
                                    "Compounded Months: ${account['compounded_months']}"),
                              const SizedBox(height: 4),
                              Text(
                                  "Notes: ${account['account_notes'] ?? 'N/A'}"),
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
