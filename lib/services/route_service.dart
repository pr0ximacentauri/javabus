import 'package:flutter/material.dart';
import 'package:javabus/helpers/session_helper.dart';
import 'package:javabus/models/bus_route.dart';
import 'package:javabus/models/city.dart';
import 'package:http/http.dart' as http;
import 'package:javabus/const/api_url.dart' as url;
import 'dart:convert';

class RouteService {
  final String apiUrl = '${url.baseUrl}/BusRoute';
  final String apiCityUrl = '${url.baseUrl}/City';

  Future<List<BusRoute>?> getRoutes() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => BusRoute.fromJson(json)).toList();
    } else {
      return null;
    }
  }

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

  Future<bool> createRoute(int originCityId, int destinationCityId) async {
    try{
      final token = await SessionHelper.getToken();
      final response = await http.post(
        Uri.parse('$apiUrl/bulk'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode([
          {
            'originCityId': originCityId,
            'destinationCityId': destinationCityId
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

  Future<bool> updateRoute(int id, int originCityId, int destinationCityId) async {
    try{
      final token = await SessionHelper.getToken();
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode([
          {
            'originCityId': originCityId,
            'destinationCityId': destinationCityId
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


  Future<bool> deleteRoute(int id) async {
    try{
      final token = await SessionHelper.getToken();
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
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