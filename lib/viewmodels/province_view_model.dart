import 'package:flutter/material.dart';
import 'package:javabus/models/province.dart';
import 'package:javabus/services/province_service.dart';

class ProvinceViewModel extends ChangeNotifier {
  final ProvinceService _service = ProvinceService();
  List<Province> provinces = [];
  bool isLoading = false;
  String? msg;

  Future<void> fetchProvinces() async {
    isLoading = true;
    notifyListeners();

    final result = await _service.getProvinces();
    if (result != null) {
      provinces = result;
      msg = null;
    } else {
      msg = 'Gagal memuat data provinsi';
    }

    isLoading = false;
    notifyListeners();
  }
}
