import 'dart:convert';

import 'package:javabus/const/api_url.dart' as url;
import 'package:http/http.dart' as http;
import 'package:javabus/models/bus_seat.dart';

class BusSeatService {
  final String apiUrl = '${url.baseUrl}/BusSeat';

  Future<List<BusSeat>?> getBusSeats() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => BusSeat.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<List<BusSeat>?> getBusSeatsByBus(int busId) async {
    final response = await http.get(Uri.parse('$apiUrl/bus/$busId'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => BusSeat.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<bool> createBusSeat(String seatNumber, int busId) async {
    try{
      final response = await http.post(
        Uri.parse('$apiUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'seatNumber': seatNumber,
            'busId': busId
          }
        ),
      );

    if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  Future<bool> updateBusSeat(int id, String seatNumber, int busId) async {
    try{
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'seatNumber': seatNumber,
            'busId': busId
          }
        ),
      );

    if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  Future<bool> deleteBusSeat(int id) async {
    try{
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode([id]),
      );

    if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}