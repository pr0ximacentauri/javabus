import 'package:flutter/material.dart';
import 'package:javabus/models/bus.dart';
import 'package:javabus/services/bus_service.dart';

class BusViewModel extends ChangeNotifier {
  final BusService _service = BusService();

  List<Bus> buses = [];
  Bus? newBus;
  String? msg;
  bool isLoading = false;

  Future<void> fetchBuses() async {
    isLoading = true;
    notifyListeners();

    final result = await _service.getBuses();
    if (result != null) {
      buses = result;
      msg = null;
    } else {
      msg = 'Gagal memuat data bus';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Bus?> getBusById(int id) async {
    final bus = await _service.getById(id);
    if (bus == null) {
      msg = 'Bus dengan ID $id tidak ditemukan';
      notifyListeners();
    }
    return bus;
  }

  Future<bool> createBus(String name, String busClass, int totalSeat) async {
    final result = await _service.createBus(name, busClass, totalSeat);
    if (result) {
      await fetchBuses();
      return true;
    } else {
      msg = 'Gagal menambahkan bus';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBus(int id, String name, String busClass, int totalSeat) async {
    final result = await _service.updateBus(id, name, busClass, totalSeat);
    if (result) {
      await fetchBuses();
      return true;
    } else {
      msg = 'Gagal memperbarui bus';
      notifyListeners();
      return false;
    }
  }


  Future<bool> deleteBus(int id) async {
    final result = await _service.deleteBus(id);
    if (result) {
      await fetchBuses();
      return true;
    } else {
      msg = 'Gagal menghapus bus';
      notifyListeners();
      return false;
    }
  }
}
