import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/services/web3_service.dart';

class ListingsScreen extends StatefulWidget {
  @override
  _ListingsScreenState createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  late Future<List<Map<String, dynamic>>> futurePanels;

  @override
  void initState() {
    super.initState();
    // Get Web3Service from Provider and fetch panels
    final web3Service = Provider.of<Web3Service>(context, listen: false);
    // Replace 'your_owner_address' with the actual owner address you want to query
    futurePanels = web3Service.getAvailablePanels('your_owner_address');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Available Listings'),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: futurePanels,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Loading state
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final panels = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: panels.length + 1, // Include one static panel
                    itemBuilder: (context, index) {
                      if (index < panels.length) {
                        final panel = panels[index];
                        return Card(
                          child: ListTile(
                            title:
                                Text('Solar Panel - ${panel['capacity']} kWh'),
                            subtitle:
                                Text('Price: ${panel['rentalRate']} tokens'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                // Logic for renting a panel
                              },
                              child: const Text('Rent'),
                            ),
                          ),
                        );
                      } else {
                        // Add a static listing at the end
                        return Card(
                          child: ListTile(
                            title: const Text('Static Solar Panel - 5 kWh'),
                            subtitle: const Text('Price: 30 tokens'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                // Logic for renting this static panel
                              },
                              child: const Text('Rent'),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              } else {
                return const Text('No listings available');
              }
            },
          ),
        ],
      ),
    );
  }
}
