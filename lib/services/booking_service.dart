import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:javabus/models/booking.dart';
import 'package:javabus/const/api_url.dart' as url;

class BookingService {
  final String apiUrl = '${url.baseUrl}/Booking';

  Future<Booking?> createBooking(int userId, int scheduleId) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'scheduleId': scheduleId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create booking: ${response.body}');
    }
  }

  Future<List<Booking>> getBookingsByUser(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl/user/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Booking.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mendapatkan data booking: ${response.body}');
    }
  }
}