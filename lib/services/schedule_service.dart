import 'dart:convert';
import 'package:javabus/const/api_url.dart' as url;
import 'package:http/http.dart' as http;
import 'package:javabus/helpers/session_helper.dart';
import 'package:javabus/models/schedule.dart';

class ScheduleService {
  final String apiUrl = '${url.baseUrl}/Schedule';


  Future<List<Schedule>?> getSchedules() async {
    final token = await SessionHelper.getToken();
    final response = await http.get(Uri.parse(apiUrl), 
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Schedule.fromJson(json)).toList();
    } else {
      return null;
    }
  } 

  Future<List<Schedule>?> searchSchedules(int routeId, String date) async {
    final token = await SessionHelper.getToken();
    final response = await http.get(Uri.parse('$apiUrl/search?routeId=$routeId&date=$date'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      return jsonData.map<Schedule>((json) => Schedule.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<Schedule?> getScheduleById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Schedule.fromJson(jsonData);
    } else {
      return null;
    }
  }

  Future<bool> createSchedule(DateTime departureTime, int ticketPrice, int busId, int routeId) async {
    try{
      final token = await SessionHelper.getToken();
      final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'departureTime': DateTime.utc(
              departureTime.year,
              departureTime.month,
              departureTime.day,
              departureTime.hour,
              departureTime.minute,
            ).toIso8601String(),
          'ticketPrice': ticketPrice,
          'busId': busId,
          'routeId': routeId
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      print('Create Schedule failed: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  Future<bool> updateSchedule(int id, DateTime departureTime, int ticketPrice, int busId, int routeId) async {
    try{
      final token = await SessionHelper.getToken();
      final response = await http.put(Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'departureTime': DateTime.utc(
              departureTime.year,
              departureTime.month,
              departureTime.day,
              departureTime.hour,
              departureTime.minute,
            ).toIso8601String(),
          'ticketPrice': ticketPrice,
          'busId': busId,
          'routeId': routeId
        }),
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

  Future<bool> deleteSchedule(int id) async {
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
