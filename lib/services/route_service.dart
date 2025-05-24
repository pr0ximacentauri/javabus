import 'package:flutter/material.dart';
import 'package:javabus/models/bus_route.dart';
import 'package:javabus/models/city.dart';
import 'package:http/http.dart' as http;
import 'package:javabus/const/api_url.dart' as url;
import 'dart:convert';

class RouteService {
  final String apiUrl = '${url.baseUrl}/Route';

  Future<int?> getId(int originId, int destinationId) async {
    final response = await http.get(Uri.parse('$apiUrl/by-city?originId=$originId&destinationId=$destinationId'));

    try{
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['routeId'];
      } else {
        debugPrint("Gagal mendapatkan ID rute: ${response.body}");
        return null;
      }
    }catch(e){
      return null;
    }
  }

  Future<List<City>?> getOrigins() async {
  final response = await http.get(Uri.parse('$apiUrl/origins'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map<City>((json) => City.fromJson(json)).toList();
  } else {
    return null;
  }
}


  Future<List<City>?> getDestinations(int originId) async{
    final response = await http.get(Uri.parse('$apiUrl/destinations/$originId'));

    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body);
      return data.map<City>((json) => City.fromJson(json)).toList();
    }else{
      return null;
    }
  }

  Future<bool> checkRoute(int originId, int destinationId) async{
    final response = await http.get(Uri.parse('$apiUrl/by-city?originId=$originId&destinationId=$destinationId'));
    
    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }

  // untuk admin
  Future<BusRoute?> createRoute(BusRoute route) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(route.toJson()),
    );

    if (response.statusCode == 201) {
      return BusRoute.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}