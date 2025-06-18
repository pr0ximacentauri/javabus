import 'dart:convert';
import 'package:javabus/const/api_url.dart' as url;
import 'package:http/http.dart' as http;
import 'package:javabus/helpers/session_helper.dart';
import 'package:javabus/models/seat_booking.dart';

class SeatBookingService{
  final String apiUrl = '${url.baseUrl}/SeatBooking';

  Future<List<SeatBooking>?> getSeatBookings() async {
    final token = await SessionHelper.getToken();
    final response = await http.get(Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => SeatBooking.fromJson(json)).toList();
    } else {
      return null;
    }
  } 

  Future<List<SeatBooking>?> getSeatBookingSchedules(int scheduleId) async {
    final token = await SessionHelper.getToken();
    final response = await http.get(Uri.parse('$apiUrl/schedule/$scheduleId'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

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


  Future<bool> createSeatBooking(int bookingId, int scheduleId, int seatId) async {
    try{
      final token = await SessionHelper.getToken();
      final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'bookingId': bookingId,
          'scheduleId': scheduleId,
          'seatId': seatId,
        }),
      );

      // print('🔧 SeatBooking → Status: ${response.statusCode}');
      // print('🔧 SeatBooking → Body: ${response.body}');
      // print('🔧 SeatBooking → Data: bookingId=$bookingId, scheduleId=$scheduleId, seatId=$seatId');


      if (response.statusCode == 200 || response.statusCode == 201) {
          return true;
        }
      return false;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  Future<bool> updateSeatBooking(int id, int bookingId, int scheduleId, int seatId) async {
    try{
      final token = await SessionHelper.getToken();
      final response = await http.put(Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'bookingId': bookingId, 
          'scheduleId': scheduleId,
          'seatId': seatId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
          return true;
        }
      return false;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  Future<bool> deleteSeatBooking(int id) async {
    try{
      final token = await SessionHelper.getToken();
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode([id]),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}

