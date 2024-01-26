import 'package:flutter/material.dart';
import 'package:netflix/services/database.dart';
import 'package:netflix/widgets/navigation_bar.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final DatabaseService _databaseService = DatabaseService();
  String? email;
  String? username;
  String? name;
  String? surname;

  @override
  void initState() {
    super.initState();
    _databaseService.getCurrentUser().then((user) {
      setState(() {
        username = user?.username;
        name = user?.name;
        surname = user?.surname;
        email = user?.email;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Account Details'),
        centerTitle: true,
      ),
      drawer: const NavigationDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Username', username),
            _buildDetailItem('Email', email),
            _buildDetailItem('Name', name),
            _buildDetailItem('Surname', surname),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          value ?? 'N/A',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
