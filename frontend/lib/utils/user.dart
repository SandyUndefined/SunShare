import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _walletAddress = '';

  String get walletAddress => _walletAddress;

  void setWalletAddress(String address) {
    _walletAddress = address;
    notifyListeners();
  }
}
