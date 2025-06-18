import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:javabus/const/api_url.dart' as url;
import 'package:javabus/helpers/session_helper.dart';

class PaymentService {
  Future<String?> createSnapPayment({required int grossAmount, required int bookingId}) async {
    final String apiUrl = '${url.baseUrl}/Payment';

    final body = {
      "grossAmount": grossAmount,
      "bookingId": bookingId,
    };

    final token = await SessionHelper.getToken();
    final response = await http.post(
      Uri.parse('$apiUrl/snap'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print('✅ URL didapat dari backend: ${json['payment_url']}');
      return json['payment_url'];
    } else {
      return null;
    }
  }
}
