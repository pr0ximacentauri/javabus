import 'dart:convert';
import 'package:javabus/const/api_url.dart' as url;
import 'package:http/http.dart' as http;
import 'package:javabus/models/seat_booking.dart';

class SeatBookingService{
  final String apiUrl = '${url.baseUrl}/SeatBooking';

  Future<List<SeatBooking>?> getSeatBookingSchedules(int scheduleId) async {
    final response = await http.get(Uri.parse('$apiUrl/schedule/$scheduleId'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => SeatBooking.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<SeatBooking?> getById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SeatBooking.fromJson(data);
    } else {
      return null;
    }
  }

  Future<SeatBooking?> createSeatBooking(int scheduleId, int seatId, int bookingId) async {
    final response = await http.post(Uri.parse('$apiUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'scheduleId': scheduleId,
        'seatId': seatId,
        'bookingId': bookingId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return SeatBooking.fromJson(data);
    } else {
      return null;
    }
  }

}