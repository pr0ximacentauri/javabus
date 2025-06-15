import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:javabus/models/province.dart';
import 'package:javabus/const/api_url.dart' as url;

class ProvinceService {
  final String apiUrl = '${url.baseUrl}/Province';

  Future<List<Province>?> getProvinces() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Province.fromJson(json)).toList();
    } else {
      return null;
    }
  }
}
