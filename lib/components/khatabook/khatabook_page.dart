import 'package:flutter/material.dart';
import 'package:learningdart/components/khatabook/createnewuser_page.dart';
import 'package:learningdart/components/khatabook/khatabook_usersview.dart';
import 'package:learningdart/components/khatabook/showamount_givingpage.dart';

class KhatabookPage extends StatefulWidget {
  const KhatabookPage({super.key});

  @override
  State<KhatabookPage> createState() => _KhatabookPageState();
}

class _KhatabookPageState extends State<KhatabookPage> {
  // Action to perform when the card is clicked
  void _onCardTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatenewuserPage()),
    );
    // You can navigate to another page or perform other actions here
  }

// Navigate to new page
  void _navigateToPage(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => destination,
      ),
    );
  }

  // Widget for individual card
  // Widget for individual card
  Widget _buildCard(BuildContext context, CardItem cardItem) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => _navigateToPage(context, cardItem.destination),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(cardItem.icon, size: 30, color: Colors.black),
              const SizedBox(width: 20),
              Text(
                cardItem.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardItems = [
      CardItem(
        icon: Icons.person_add,
        title: 'Create a New User',
        destination: const CreatenewuserPage(),
      ),
      CardItem(
        icon: Icons.book,
        title: 'View Transactions',
        destination: const NewPage(title: 'View Transactions'),
      ),
      CardItem(
        icon: Icons.analytics,
        title: 'View Analytics',
        destination: const NewPage(title: 'View Analytics'),
      ),
      CardItem(
        icon: Icons.book_online_outlined,
        title: 'Khatabook',
        destination: const KhatabookUsersView(),
      ),
      // Add more CardItems as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Khatabook'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: cardItems
                    .map((cardItem) => _buildCard(context, cardItem))
                    .toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 7.5), // Space between buttons
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AmountGivingPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shadowColor: Colors.black.withOpacity(0.3),
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Credit',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 7.5), // Space between buttons
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your "Debit" button action here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shadowColor: Colors.black.withOpacity(0.3),
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Debit',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CardItem {
  final IconData icon;
  final String title;
  final Widget destination;

  CardItem(
      {required this.icon, required this.title, required this.destination});
}

class NewPage extends StatelessWidget {
  final String title;

  const NewPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'This is the $title page',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
