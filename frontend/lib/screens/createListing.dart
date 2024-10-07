import 'package:flutter/material.dart';

class CreateListingScreen extends StatelessWidget {
  final _capacityController = TextEditingController();
  final _rateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Create New Listing'),
          TextField(
            controller: _capacityController,
            decoration: const InputDecoration(labelText: 'Capacity (kWh)'),
          ),
          TextField(
            controller: _rateController,
            decoration: const InputDecoration(labelText: 'Rental Rate (tokens)'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logic for creating a listing
            },
            child: const Text('Create Listing'),
          ),
        ],
      ),
    );
  }
}
