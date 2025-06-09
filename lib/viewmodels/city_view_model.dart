import 'package:flutter/material.dart';
import 'package:javabus/models/city.dart';
import 'package:javabus/services/city_service.dart';

class CityViewModel extends ChangeNotifier {
  final CityService _service = CityService();

  List<City> cities = [];
  City? newCity;
  City? selectedCity;
  String? msg;
  bool isLoading = false;

  Future<void> fetchCities() async {
    isLoading = true;
    notifyListeners();

    final result = await _service.getCities();
    if (result != null) {
      cities = result;
      msg = null;
    } else {
      msg = 'Gagal memuat data kota';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<City?> getCityById(int id) async {
    final city = await _service.getById(id);
    if (city == null) {
      msg = 'Kota dengan ID $id tidak ditemukan';
      notifyListeners();
    }
    return city;
  }

  List<City> searchCities(String query) {
    if (query.isEmpty) return cities;
    return cities.where((city) {
      final cityName = city.name.toLowerCase();
      final provinceName = city.province?.name.toLowerCase() ?? '';
      return cityName.contains(query.toLowerCase()) ||
            provinceName.contains(query.toLowerCase());
    }).toList();
  }


  Future<bool> createCity(String name, int provinceId) async {
    final result = await _service.createCity(name, provinceId);
    if (result) {
      await fetchCities();
      return true;
    } else {
      msg = 'Gagal menambahkan kota baru';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCity(int id, String name, int provinceId) async {
    final result = await _service.updateCity(id, name, provinceId);
    if (result) {
      await fetchCities();
      return true;
    } else {
      msg = 'Gagal memperbarui kota';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCity(int id) async {
    final result = await _service.deleteCity(id);
    if (result) {
      await fetchCities();
      return true;
    } else {
      msg = 'Gagal menghapus kota';
      notifyListeners();
      return false;
    }
  }
}
