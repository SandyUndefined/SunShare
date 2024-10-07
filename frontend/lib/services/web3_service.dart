import 'dart:convert';
import 'package:http/http.dart' as http;

class Web3Service {
  final String aptosApiUrl = 'https://fullnode.devnet.aptoslabs.com/v1';

  Future<dynamic> callFunction(
      String moduleAddress, String functionName, List<dynamic> args) async {
    final url = Uri.parse(
        '$aptosApiUrl/accounts/$moduleAddress/resource/$functionName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to call function');
    }
  }

  Future<void> createListing(
      int ratePerHour, int deposit, int availableHours) async {
    // Add the logic to send a transaction for creating a listing.
  }

  Future<void> rentEnergy(int listingId, int hoursRented, int deposit) async {
    // Add the logic to send a transaction for renting energy.
  }

  Future<void> endRental(int rentalId) async {
    // Add the logic to send a transaction for ending the rental.
  }
}
