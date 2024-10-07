import 'package:flutter/material.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/intro_screen.dart';
import 'package:frontend/screens/login.dart';
import 'package:provider/provider.dart';
import 'services/web3_service.dart';
import 'utils/user.dart'; // Make sure you import UserProvider

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => Web3Service()),  // Your Web3Service provider
        ChangeNotifierProvider(create: (_) => UserProvider()),  // Add UserProvider here
      ],
      child: MaterialApp(
        title: 'SunShare DApp',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => const IntroScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => const HomeScreen(userAddress: ''),
        },
      ),
    );
  }
}
