import 'package:flutter/material.dart';
import 'package:javabus/models/city.dart';
import 'package:javabus/services/route_service.dart';

class RouteViewModel extends ChangeNotifier {
  final RouteService _service = RouteService();

  List<City> origins = [];
  List<City> destinations = [];

  City? selectedOrigin;
  City? selectedDestination;

  String? msg;

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
      msg = "Kota asal dan tujuan harus dipilih.";
      notifyListeners();
      return false;
    }

    final exists = await _service.checkRoute(
      selectedOrigin!.id,
      selectedDestination!.id,
    );

    // if (!exists) {
    //   await _service.createRoute(RouteModel(
    //     id: 0,
    //     originCityId: selectedOrigin!.id,
    //     destinationCityId: selectedDestination!.id,
    //   ));
    //   msg = "Rute baru telah ditambahkan.";
    // } else {
    //   msg = "Rute sudah tersedia dan siap digunakan.";
    // }
    if(!exists){
      msg = "Rute ini belum tersedia.";
    }

    notifyListeners();
    return true;
  }

  Future<bool> swapRoute() async {
  if (selectedOrigin == null || selectedDestination == null) {
    msg = 'Asal dan tujuan belum dipilih.';
    notifyListeners();
    return false;
  }

  // Coba cek apakah rute terbalik tersedia
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
      msg = 'Rute dari ${selectedDestination!.name} ke ${selectedOrigin!.name} tidak tersedia.';
      notifyListeners();
      return false;
    }
  }

}