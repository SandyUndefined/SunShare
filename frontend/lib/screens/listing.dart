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
    futurePanels = web3Service.getAvailablePanels('9063b0cae7dd97c0491259a99ef90b35a93d26248c3a4c295872b158cbfdcac7');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: futurePanels,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Loading state
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                // Handle no available listings
                return const Text('No available listings');
              } else if (snapshot.hasData) {
                final panels = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: panels.length, // List of available panels
                    itemBuilder: (context, index) {
                      final panel = panels[index];
                      return Card(
                        child: ListTile(
                          title: Text('Solar Panel - ${panel['capacity']} kWh'),
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
                    },
                  ),
                );
              } else {
                return const Text(
                    'No available listings'); // Default empty state
              }
            },
          ),
        ],
      ),
    );
  }
}
