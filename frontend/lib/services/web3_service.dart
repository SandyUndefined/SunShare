import 'package:http/http.dart' as http;

class Web3Service {
  // Function to check if the Aptos wallet address is valid
  Future<bool> checkWalletAddress(String address) async {
    final url = Uri.parse(
        'https://fullnode.devnet.aptoslabs.com/v1/accounts/$address');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // The wallet address is valid
      return true;
    } else {
      // The wallet address is not valid
      return false;
    }
  }
}
