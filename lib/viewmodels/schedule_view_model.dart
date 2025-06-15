import 'package:flutter/material.dart';
import 'package:javabus/models/schedule.dart';
import 'package:javabus/services/schedule_service.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ScheduleService _service = ScheduleService();

  List<Schedule> schedules = [];
  bool isLoading = false;
  String? msg;

  Future<void> getSchedulesByRouteAndDate(int routeId, String date) async {
    isLoading = true;
    notifyListeners();

    final result = await _service.searchSchedules(routeId, date);
    if (result == null) {
      msg = "Jadwal tidak ditemukan untuk tanggal tersebut.";
    } else {
      schedules = result;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSchedules() async {
    isLoading = true;
    notifyListeners();

    final result = await _service.getSchedules();
    if (result != null) {
      schedules = result;
      msg = null;
    } else {
      msg = 'Gagal memuat data jadwal';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> createSchedule(DateTime departureTime, int ticketPrice, int busId, int routeId) async {
    final result = await _service.createSchedule(departureTime, ticketPrice, busId, routeId);
    if (result) {
      await fetchSchedules();
      return true;
    } else {
      msg = 'Gagal menambahkan jadwal bus';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSchedule(int id, DateTime departureTime, int ticketPrice, int busId, int routeId) async {
    final result = await _service.updateSchedule(id, departureTime, ticketPrice, busId, routeId);
    if (result) {
      await fetchSchedules();
      return true;
    } else {
      msg = 'Gagal memperbarui jadwal bus';
      notifyListeners();
      return false;
    }
  }


  Future<bool> deleteBusSeat(int id) async {
    final result = await _service.deleteSchedule(id);
    if (result) {
      await fetchSchedules();
      return true;
    } else {
      msg = 'Gagal menghapus jadwal bus';
      notifyListeners();
      return false;
    }
  }
}