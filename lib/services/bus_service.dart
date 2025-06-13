import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:javabus/const/api_url.dart' as url;
import 'package:javabus/helpers/session_helper.dart';
import 'package:javabus/models/bus.dart';

class BusService {
  final String apiUrl = '${url.baseUrl}/Bus';

  Future<List<Bus>?> getBuses() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Bus.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<Bus?> getById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Bus.fromJson(data);
    } else {
      return null;
    }
  }

  Future<bool> createBus(String name, String busClass, int totalSeat) async {
    try {
      final token = await SessionHelper.getToken();
      final response = await http.post(
        Uri.parse('$apiUrl/bulk'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode([
          {
            'name': name,
            'busClass': busClass,
            'totalSeat': totalSeat,
          }
        ]),
      );

      // print('Create status: ${response.statusCode}');
      // print('Create body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }


  Future<bool> updateBus(int id, String name, String busClass, int totalSeat) async {
    try {
      final token = await SessionHelper.getToken();
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          {
            'name': name,
            'busClass': busClass,
            'totalSeat': totalSeat,
          }
        ),
      );

      // print('Create status: ${response.statusCode}');
      // print('Create body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  Future<bool> deleteBus(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      // print('Delete failed: ${response.statusCode}');
      // print('Body: ${response.body}');
      return false;
    }
  }

}