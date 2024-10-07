import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Logic to connect to Aptos Wallet or call webview for login
            // Once logged in, navigate to home
            Navigator.pushNamed(context, '/home');
          },
          child: const Text('Connect to Aptos Wallet'),
        ),
      ),
    );
  }
}
