import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:javabus/const/api_url.dart' as url;
import 'package:javabus/models/city.dart';

class CityService {
  final String apiUrl = '${url.baseUrl}/City';

  Future<List<City>?> getCities() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      final List data = jsonDecode(response.body);

      return data.map((json) => City.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<City?> getById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return City.fromJson(data);
    } else {
      return null;
    }
  }

  Future<bool> createCity(String name, int provinceId) async {
    try{
      final response = await http.post(
        Uri.parse('$apiUrl/bulk'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode([
          {
            'name': name,
            'provinceId': provinceId
          }
        ]),
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

  Future<bool> updateCity(int id, String name, int provinceId) async {
    try{
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'name': name,
            'provinceId': provinceId
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

  Future<bool> deleteCity(int id) async {
    try{
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
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