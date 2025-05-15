import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:javabus/const/api_url.dart' as url;
import 'package:javabus/models/bus.dart';

class BusService {
  final String apiUrl = '${url.baseUrl}/Bus';

  Future<List<Bus>> getBuses() async {
    final response = await http.get(Uri.parse('$apiUrl'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Bus.fromJson(json)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  Future<Bus> getById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Bus.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }
}