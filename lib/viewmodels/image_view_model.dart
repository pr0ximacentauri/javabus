import 'dart:io';
import 'package:flutter/material.dart';
import 'package:javabus/services/cloudinary_service.dart';

class ImageViewModel with ChangeNotifier {
  bool _isUploading = false;
  String? _imageUrl;
  String? _error;

  bool get isUploading => _isUploading;
  String? get imageUrl => _imageUrl;
  String? get error => _error;

  Future<void> uploadImage(File imageFile) async {
    _isUploading = true;
    _error = null;
    notifyListeners();

    final url = await CloudinaryService.uploadImage(imageFile);
    if (url != null) {
      _imageUrl = url;
    } else {
      _error = 'Gagal upload gambar. Periksa ukuran atau format file.';
    }

    _isUploading = false;
    notifyListeners();
  }

  void clear() {
    _imageUrl = null;
    _error = null;
    notifyListeners();
  }
}
