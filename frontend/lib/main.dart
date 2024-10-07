import 'package:flutter/material.dart';
import 'package:frontend/screens/home.dart';
import 'package:provider/provider.dart';
import './services/web3_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => Web3Service()),
      ],
      child: MaterialApp(
        title: 'SunShare DApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          // '/create-listing': (context) => CreateListingScreen(),
          // '/rent-energy': (context) => RentEnergyScreen(),
        },
      ),
    );
  }
}
