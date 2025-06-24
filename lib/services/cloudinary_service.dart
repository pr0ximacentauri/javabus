import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:javabus/const/cloudinary_url.dart' as url;

class CloudinaryService {
  static String cloudName = url.cloudName;
  static String uploadPreset = url.uploadPreset;
  static const int maxFileSize = 4 * 1024 * 1024;
  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png'];

  static Future<String?> uploadImage(File imageFile) async {
    final ext = extension(imageFile.path).toLowerCase();
    final fileSize = await imageFile.length();

    if (!allowedExtensions.contains(ext.replaceAll('.', ''))) {
      print('Tipe file tidak didukung: $ext');
      return null;
    }

    if (fileSize > maxFileSize) {
      print('Ukuran file melebihi batas');
      return null;
    }

    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final json = jsonDecode(responseBody);
      // print('Cloudinary upload success: ${json['secure_url']}');
      return json['secure_url'];
    } else {
      // print('Cloudinary upload failed (${response.statusCode})');
      // print('Body: $responseBody');
      return null;
    }
  }
}
