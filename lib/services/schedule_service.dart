
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:javabus/models/schedule.dart';

class ScheduleService {
  final String apiUrl = 'https://localhost:32771/api/Schedule';

  Future<List<Schedule>> getSchedules(int routeId, String date) async {
    final response = await http.get(Uri.parse('$apiUrl/search?routeId=$routeId&date=$date'));

    if(response.statusCode == 200){
      final List jsonData = jsonDecode(response.body);
      return jsonData.map<Schedule>((json) => Schedule.fromJson(json)).toList();
    }else{
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }
  
}