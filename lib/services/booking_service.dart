import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:javabus/models/booking.dart';
import 'package:javabus/const/api_url.dart' as url;

class BookingService {
  final String apiUrl = '${url.baseUrl}/Booking';

  Future<Booking?> createBooking(int userId, int scheduleId) async {
    final response = await http.post(Uri.parse('$apiUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'scheduleId': scheduleId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Booking.fromJson(data);
    } else {
      return null;
    }
  }

  Future<List<Booking>?> getBookingsByUser(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl/user/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Booking.fromJson(e)).toList();
    } else {
      return null;
    }
  }


  Future<bool> updateBookingStatus(int bookingId, String status) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$bookingId/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}