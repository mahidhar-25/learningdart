import 'package:flutter/material.dart';
import 'package:learningdart/components/khatabook/users_db.dart';

class KhatabookUsersView extends StatefulWidget {
  const KhatabookUsersView({super.key});

  @override
  State<KhatabookUsersView> createState() => _KhatabookUsersViewState();
}

class _KhatabookUsersViewState extends State<KhatabookUsersView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Name';
  /*
   List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'name': 'John Doe',
      'phone_no': '1234567890',
      'village': 'Village A',
    },
    {
      'id': 2,
      'name': 'Jane Smith',
      'phone_no': '0987654321',
      'village': 'Village B',
    },
    {
      'id': 3,
      'name': 'mahidhar',
      'phone_no': '1234567890',
      'village': 'Village A',
    },
    {
      'id': 4,
      'name': 'karthik',
      'phone_no': '0987654321',
      'village': 'Village B',
    },
    {
      'id': 5,
      'name': 'John Doe',
      'phone_no': '1234567890',
      'village': 'Village A',
    },
    {
      'id': 6,
      'name': 'Jane Smith',
      'phone_no': '0987654321',
      'village': 'Village B',
    },
    {
      'id': 7,
      'name': 'mahidhar',
      'phone_no': '1234567890',
      'village': 'Village A',
    },
    {
      'id': 8,
      'name': 'karthik',
      'phone_no': '0987654321',
      'village': 'Village B',
    },
    {
      'id': 9,
      'name': 'John Doe',
      'phone_no': '1234567890',
      'village': 'Village A',
    },
    {
      'id': 10,
      'name': 'Jane Smith',
      'phone_no': '0987654321',
      'village': 'Village B',
    },
    {
      'id': 11,
      'name': 'mahidhar',
      'phone_no': '1234567890',
      'village': 'Village A',
    },
    {
      'id': 12,
      'name': 'karthik',
      'phone_no': '0987654321',
      'village': 'Village B',
    },

    // Add more users as needed
  ];

  late List<Map<String, dynamic>> _filteredUsers;
*/
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch data from the database on widget load
  }

  Future<void> _fetchUsers() async {
    // Simulate a database call. Replace this with your actual database call.
    final List<Map<String, dynamic>> usersFromDb =
        await KhatabookUser().getAllUsers();

    setState(() {
      _users = usersFromDb;
      _filteredUsers = _users; // Initialize the filtered list
    });
  }

  void _filterUsers() {
    setState(() {
      _filteredUsers = _users.where((user) {
        final searchQuery = _searchController.text.toLowerCase();
        switch (_selectedFilter) {
          case 'Name':
            return user['name'].toLowerCase().contains(searchQuery);
          case 'Phone':
            return user['phone_number'].toLowerCase().contains(searchQuery);
          case 'Village':
            return user['village'].toLowerCase().contains(searchQuery);
          default:
            return false;
        }
      }).toList();
    });
  }

  void _navigateToUserDetails(Map<String, dynamic> user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khatabook Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (_) => _filterUsers(),
              decoration: InputDecoration(
                hintText: 'Search users',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filter by:'),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: ['Name', 'Phone', 'Village'].map((filter) {
                    return DropdownMenuItem(
                      value: filter,
                      child: Text(filter),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    _filterUsers();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        user['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        user['village'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      trailing: Text(
                        user['phone_number'],
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      onTap: () => _navigateToUserDetails(user),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetailsPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${user['name']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Village: ${user['village']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Phone: ${user['phone_number']}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
