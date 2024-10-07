import 'dart:convert';
import 'package:http/http.dart' as http;

class Web3Service {
  // Function to check if the Aptos wallet address is valid
  Future<bool> checkWalletAddress(String address) async {
    final url =
        Uri.parse('https://fullnode.devnet.aptoslabs.com/v1/accounts/$address');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // The wallet address is valid
      return true;
    } else {
      // The wallet address is not valid
      return false;
    }
  }

  // Function to get available solar panel listings from the blockchain
  Future<List<Map<String, dynamic>>> getAvailablePanels(
      String ownerAddress) async {
    final url = Uri.parse(
        'https://fullnode.devnet.aptoslabs.com/v1/accounts/$ownerAddress/resource/0x9063b0cae7dd97c0491259a99ef90b35a93d26248c3a4c295872b158cbfdcac7::SolarPanelRental::PanelRegistry');

    final response = await http.get(url);
    print(response.statusCode);

    // If the resource does not exist, return an empty list
    if (response.statusCode == 404) {
      print('No available listings'); // Log for debugging
      return []; // Return an empty list
    }

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('data')) {
        final panels = data['data']['panels'] as List<dynamic>;
        // Map the fetched panels to a list of maps with relevant details (capacity, rentalRate, isRented)
        return panels
            .map((panel) => {
                  'capacity': panel['capacity'],
                  'rentalRate': panel['rental_rate'],
                  'isRented': panel['is_rented']
                })
            .toList();
      } else {
        return []; // If there are no panels, return an empty list
      }
    } else {
      throw Exception(
          'Failed to load panels, Status Code: ${response.statusCode}');
    }
  }
}
