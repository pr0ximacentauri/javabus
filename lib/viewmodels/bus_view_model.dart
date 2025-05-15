import 'package:flutter/material.dart';
import 'package:javabus/models/bus.dart';
import 'package:javabus/services/bus_service.dart';

class BusViewModel extends ChangeNotifier{
  final BusService _service = BusService();

  List<Bus> buses = [];
  String? errorMsg;
  bool isLoading = false;

  Future<void> fetchBuses() async {
    isLoading = true;
    notifyListeners();

    try {
      buses = await _service.getBuses();
      errorMsg = null;
    } catch (e) {
      errorMsg = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<Bus> getBusById(int id) async {
    try{
      return await _service.getById(id);
    }catch(e){
      throw Exception(e.toString());
    }
  }
}