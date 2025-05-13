import 'package:javabus/models/route.dart';
import 'package:javabus/models/city.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteService {
  static const baseUrl = 'https://localhost:32771/api/Route';

  Future<List<City>> getOrigins() async {
  final response = await http.get(Uri.parse('$baseUrl/origins'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    // debug log
    for (var city in data) {
      print(city); // periksa apakah ada 'province': null
    }

    return data.map<City>((json) => City.fromJson(json)).toList();
  } else {
    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? 'Unknown error');
  }
}


  Future<List<City>> getDestinations(int originId) async{
    final response = await http.get(Uri.parse('$baseUrl/destinations/$originId'));

    try{
      if(response.statusCode == 200){
        final List<dynamic> data = json.decode(response.body);
        return data.map<City>((json) => City.fromJson(json)).toList();
      }else{
        throw Exception(json.decode(response.body)['message']);
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }

  Future<bool> checkRoute(int originId, int destinationId) async{
    final response = await http.get(Uri.parse('$baseUrl/$originId/$destinationId'));
    
    try{
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }

  // untuk admin
  Future<RouteModel> createRoute(RouteModel route) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(route.toJson()),
    );

    if (response.statusCode == 201) {
      return RouteModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal menambahkan rute');
    }
  }
}