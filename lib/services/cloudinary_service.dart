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
    final fileSize = await imageFile.length();
    final fileExtension = extension(imageFile.path).toLowerCase().replaceAll('.', '');

    if (!allowedExtensions.contains(fileExtension)) {
      print('Format file tidak didukung. Hanya JPG, JPEG, PNG yang diperbolehkan.');
      return null;
    }

    if (fileSize > maxFileSize) {
      print('Ukuran file terlalu besar. Maksimal 2 MB.');
      return null;
    }

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        final jsonData = jsonDecode(resBody);
        return jsonData['secure_url'];
      } else {
        print('Gagal upload ke Cloudinary: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}
