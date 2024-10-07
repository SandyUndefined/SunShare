import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String userAddress; // User's wallet address after login

  const HomeScreen({super.key, required this.userAddress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SunShare')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Logged in as: $userAddress'),
          ElevatedButton(
            onPressed: () {
              if (userAddress.isNotEmpty) {
                Navigator.pushNamed(context, '/create-listing');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please log in to create a listing')),
                );
              }
            },
            child: const Text('Create a Listing'),
          ),
        ],
      ),
    );
  }
}
