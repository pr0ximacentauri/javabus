import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:javabus/models/city.dart';
import 'package:javabus/services/route_service.dart';
import 'package:latlong2/latlong.dart';

class TerminalViewModel extends ChangeNotifier {
  final RouteService _routeService = RouteService();

  LatLng? currentLocation;
  List<City>? terminals = [];
  bool isLoading = true;
  String errorMessage = '';

  TerminalViewModel() {
    init();
  }

  Future<void> init() async {
    await _determinePosition();
    await fetchTerminals();
    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshLocation() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    await _determinePosition();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTerminals() async {
    terminals = await _routeService.getOrigins();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      errorMessage = 'Layanan lokasi dinonaktifkan. Mohon aktifkan layanan lokasi.';
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorMessage = 'Izin lokasi ditolak.';
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      errorMessage = 'Izin lokasi ditolak secara permanen.';
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      errorMessage = 'Gagal mendapatkan lokasi: ${e.toString()}';
    }
  }
}
