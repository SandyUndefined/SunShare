import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Web3Service {
  final String privateKey =
      '0xc78df74c67abaf012b5f924da0742319361114fed62dff5d205479c64f1783d5';
  final String accountAddress =
      '9063b0cae7dd97c0491259a99ef90b35a93d26248c3a4c295872b158cbfdcac7'; // Ensure the 0x prefix
  final String nodeUrl = 'https://fullnode.devnet.aptoslabs.com';
  final String faucetUrl = 'https://faucet.devnet.aptoslabs.com';
  final String signingServiceUrl = 'http://172.18.40.152:3000';


  // Function to create a new listing by calling list_panel on the blockchain
Future<void> createListing(int capacity, int rentalRate) async {
    final sequenceNumber = await getSequenceNumber();

    // Correct transaction request format with function call
  final txRequest = {
      "sender": "0x$accountAddress",
      "sequence_number": sequenceNumber,
      "max_gas_amount": "1000",
      "gas_unit_price": "1",
      "expiration_timestamp_secs":
          (DateTime.now().millisecondsSinceEpoch ~/ 1000 + 600).toString(),
      "capacity": capacity.toString(),
      "rentalRate": rentalRate.toString(),
      "payload": {
        "type": "entry_function_payload",
        "function":
            "0x$accountAddress::SolarPanelRental::list_panel", // Reference the correct function here
        "type_arguments": [],
        "arguments": [
          capacity,
          rentalRate,
        ]
      }
    };




    // Send the transaction request to the signing service
    final signedTxn = await signTransaction(txRequest);

    // Submit the signed transaction to the Aptos blockchain
    final response = await http.post(
      Uri.parse('$nodeUrl/v1/transactions'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode(signedTxn),
    );

    if (response.statusCode == 202) {
      print('Transaction submitted successfully');
    } else {
      print('Error: ${response.body}');
      throw Exception('Failed to create listing');
    }
  }


  // Function to send the transaction to the backend signing service
  Future<Map<String, dynamic>> signTransaction(
      Map<String, dynamic> txRequest) async {
    final response = await http.post(
      Uri.parse('$signingServiceUrl/sign-transaction'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode(txRequest),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error signing transaction: ${response.body}');
      throw Exception('Failed to sign transaction');
    }
  }

  // Function to get the current sequence number for the account
  Future<String> getSequenceNumber() async {
    final url = Uri.parse('$nodeUrl/v1/accounts/$accountAddress');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['sequence_number'] as String;
    } else {
      throw Exception('Failed to fetch sequence number');
    }
  }
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
