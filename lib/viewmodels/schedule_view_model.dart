import 'package:flutter/material.dart';
import 'package:javabus/models/schedule.dart';
import 'package:javabus/services/schedule_service.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ScheduleService _service = ScheduleService();

  List<Schedule> schedules = [];
  bool isLoading = false;
  String? msg;

  Future<void> getSchedulesByRouteAndDate(int routeId, String date) async {
    try {
      schedules = await _service.getSchedules(routeId, date);
      if (schedules.isEmpty) {
        msg = "Jadwal tidak ditemukan untuk tanggal tersebut.";
      } else {
        msg = null;
      }
      notifyListeners();
    } catch (e) {
      msg = e.toString();
      notifyListeners();
    }
  }

}