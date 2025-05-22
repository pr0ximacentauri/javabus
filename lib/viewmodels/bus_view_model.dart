import 'package:flutter/material.dart';
import 'package:javabus/models/bus.dart';
import 'package:javabus/services/bus_service.dart';

class BusViewModel extends ChangeNotifier {
  final BusService _service = BusService();

  List<Bus> buses = [];
  String? errorMsg;
  bool isLoading = false;

  Future<void> fetchBuses() async {
    isLoading = true;
    notifyListeners();

    final result = await _service.getBuses();
    if (result != null) {
      buses = result;
      errorMsg = null;
    } else {
      errorMsg = 'Gagal memuat data bus.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Bus?> getBusById(int id) async {
    final bus = await _service.getById(id);
    if (bus == null) {
      errorMsg = 'Bus dengan ID $id tidak ditemukan.';
      notifyListeners();
    }
    return bus;
  }
}
