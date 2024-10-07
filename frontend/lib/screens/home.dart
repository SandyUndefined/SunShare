import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/web3_service.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final web3Service = Provider.of<Web3Service>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('SunShare DApp'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to SunShare!'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create-listing');
              },
              child: Text('Create a Listing'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/rent-energy');
              },
              child: Text('Rent Energy'),
            ),
          ],
        ),
      ),
    );
  }
}
