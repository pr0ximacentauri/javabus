import 'dart:convert';
import 'package:javabus/const/api_url.dart' as url;
import 'package:http/http.dart' as http;
import 'package:javabus/models/schedule.dart';

class ScheduleService {
  final String apiUrl = '${url.baseUrl}/Schedule';


  Future<List<Schedule>?> getSchedules(int routeId, String date) async {
    final response = await http.get(Uri.parse('$apiUrl/search?routeId=$routeId&date=$date'));

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
}
