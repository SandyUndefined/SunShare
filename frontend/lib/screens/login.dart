import 'package:flutter/material.dart';
import 'package:frontend/utils/user.dart';
import 'package:provider/provider.dart';
import 'package:frontend/services/web3_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController walletAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: walletAddressController,
              decoration:
                  const InputDecoration(labelText: 'Enter Wallet Address'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final address = walletAddressController.text.trim();

                if (address.isNotEmpty) {
                  // Access UserProvider here
                  Provider.of<UserProvider>(context, listen: false)
                      .setWalletAddress(address);

                  // Navigate to Home screen
                  Navigator.pushReplacementNamed(context, '/home',
                      arguments: address);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a wallet address.')),
                  );
                }
              },
              child: const Text('Login with Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
