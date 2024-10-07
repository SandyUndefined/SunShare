import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:frontend/screens/createListing.dart';
import 'package:frontend/screens/listing.dart';
import 'package:frontend/screens/profile.dart';

class HomeScreen extends StatefulWidget {
  final String userAddress; // User's address from login

  const HomeScreen({Key? key, required this.userAddress}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ListingsScreen(), // View Listings
    CreateListingScreen(), // Create a new Listing
    const ProfileScreen(), // User Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SunShare'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.energy_savings_leaf),
            title: const Text('Listings'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.add_circle),
            title: const Text('Create Listing'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile'),
          ),
        ],
      ),
    );
  }
}
