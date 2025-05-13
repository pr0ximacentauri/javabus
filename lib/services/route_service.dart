import 'package:flutter/material.dart';
import 'package:javabus/models/route.dart';
import 'package:javabus/models/city.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteService {
  final String apiUrl = 'https://localhost:32771/api/Route';

  Future<int?> getId(int originId, int destinationId) async {
    final url = Uri.parse('$apiUrl/by-city?originId=$originId&destinationId=$destinationId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['routeId'];
    } else {
      debugPrint("Gagal mendapatkan ID rute: ${response.body}");
      return null;
    }
  }

  Future<List<City>> getOrigins() async {
  final response = await http.get(Uri.parse('$apiUrl/origins'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map<City>((json) => City.fromJson(json)).toList();
  } else {
    final error = jsonDecode(response.body);
    throw Exception(error['message']);
  }
}


  Future<List<City>> getDestinations(int originId) async{
    final response = await http.get(Uri.parse('$apiUrl/destinations/$originId'));

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
    final response = await http.get(Uri.parse('$apiUrl/by-city?originId=$originId&destinationId=$destinationId'));
    
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
      Uri.parse(apiUrl),
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