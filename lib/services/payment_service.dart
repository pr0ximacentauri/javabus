import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:javabus/const/api_url.dart' as url;
import 'package:javabus/models/payment_request.dart';

class PaymentService {
  final String apiUrl = '${url.baseUrl}/Payment';

  Future<String> createPayment(PaymentRequest request) async {
    final response = await http.post(
      Uri.parse('$apiUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['payment_url'];
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal membuat pembayaran');
    }
  }
  
}