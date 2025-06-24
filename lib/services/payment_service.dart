import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:javabus/const/api_url.dart' as url;
import 'package:javabus/helpers/session_helper.dart';
import 'package:javabus/models/payment.dart';

class PaymentService {
  final String apiUrl = '${url.baseUrl}/Payment';
  Future<String?> createSnapPayment({required int grossAmount, required int bookingId}) async {

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
      // print('URL didapat dari backend: ${json['payment_url']}');
      return json['payment_url'];
    } else {
      return null;
    }
  }

  Future<Payment?> getPaymentByBookingId(int bookingId) async {
    final token = await SessionHelper.getToken();
    final response = await http.get(
      Uri.parse('$apiUrl/booking/$bookingId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    // print('GET Payment response code: ${response.statusCode}');
    // print('GET Payment response body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Payment.fromJson(json);
    }
    return null;
  }   

}
