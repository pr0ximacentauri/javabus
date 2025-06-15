import 'package:flutter/material.dart';
import 'package:javabus/models/bus_route.dart';
import 'package:javabus/models/city.dart';
import 'package:javabus/services/route_service.dart';

class RouteViewModel extends ChangeNotifier {
  final RouteService _service = RouteService();

  List<BusRoute> busRoutes = [];
  List<City>? origins = [];
  List<City>? destinations = [];
  City? selectedOrigin;
  City? selectedDestination;
  DateTime? selectedDate;

  String? msg;
  bool isLoading = false;

  Future<int?> getRouteId() async {
    if (selectedOrigin == null || selectedDestination == null) return null;
    return await _service.getId(selectedOrigin!.id, selectedDestination!.id);
  }

  Future<void> loadOrigins() async {
    origins = await _service.getOrigins();
    notifyListeners();
  }


  Future<void> loadDestinations(int originId) async {
    destinations = await _service.getDestinations(originId);
    notifyListeners();
  }

  Future<bool> checkAvailableRoute() async {
    if (selectedOrigin == null || selectedDestination == null) {
      msg = "Kota asal dan tujuan harus dipilih";
      notifyListeners();
      return false;
    }

    final exists = await _service.checkRoute(
      selectedOrigin!.id,
      selectedDestination!.id,
    );

    if(!exists){
      msg = "Rute ini belum tersedia";
    }

    notifyListeners();
    return true;
  }

  Future<bool> swapRoute() async {
  if (selectedOrigin == null || selectedDestination == null) {
    msg = 'Asal dan tujuan belum dipilih';
    notifyListeners();
    return false;
  }

  bool exists = await _service.checkRoute(
      selectedDestination!.id,
      selectedOrigin!.id,
    );

    if (exists) {
      final temp = selectedOrigin;
      selectedOrigin = selectedDestination;
      selectedDestination = temp;
      notifyListeners();
      return true;
    } else {
      msg = 'Rute dari ${selectedDestination!.name} ke ${selectedOrigin!.name} tidak tersedia';
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchBusRoutes() async {
    isLoading = true;
    notifyListeners();

    final result = await _service.getRoutes();
    if (result != null) {
      busRoutes = result;
      msg = null;
    } else {
      msg = 'Gagal memuat data rute bus';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> createBusRoute(int originCityId, int destinationCityId) async {
    final result = await _service.createRoute(originCityId, destinationCityId);
    if (result) {
      await fetchBusRoutes();
      return true;
    } else {
      msg = 'Gagal menambahkan rute bus baru';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBusRoute(int id, int originCityId, int destinationCityId) async {
    final result = await _service.updateRoute(id, originCityId, destinationCityId);
    if (result) {
      await fetchBusRoutes();
      return true;
    } else {
      msg = 'Gagal memperbarui rute bus';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBusRoute(int id) async {
    final result = await _service.deleteRoute(id);
    if (result) {
      await fetchBusRoutes();
      return true;
    } else {
      msg = 'Gagal menghapus bus';
      notifyListeners();
      return false;
    }
  }

}