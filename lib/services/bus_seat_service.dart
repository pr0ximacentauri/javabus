import 'dart:convert';

import 'package:javabus/const/api_url.dart' as url;
import 'package:http/http.dart' as http;
import 'package:javabus/models/bus_seat.dart';

class BusSeatService {
  final String apiUrl = '${url.baseUrl}/BusSeats';

  Future<List<BusSeat>?> getBusSeats(int busId) async {
    final response = await http.get(Uri.parse('$apiUrl/bus/$busId'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => BusSeat.fromJson(json)).toList();
    } else {
      return null;
    }
  }
}