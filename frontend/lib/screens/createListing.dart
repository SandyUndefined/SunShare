import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/services/web3_service.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  _CreateListingScreenState createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _capacityController = TextEditingController();
  final _rentalRateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _capacityController,
              decoration: const InputDecoration(labelText: 'Capacity (kWh)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rentalRateController,
              decoration:
                  const InputDecoration(labelText: 'Rental Rate (tokens)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final capacity = int.tryParse(_capacityController.text);
                final rentalRate = int.tryParse(_rentalRateController.text);

                if (capacity != null && rentalRate != null) {
                  final web3Service =
                      Provider.of<Web3Service>(context, listen: false);
                  await web3Service.createListing(capacity, rentalRate);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Listing Created!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid input!')),
                  );
                }
              },
              child: const Text('Create Listing'),
            ),
          ],
        ),
      ),
    );
  }
}
