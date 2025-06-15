import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:javabus/models/booking.dart';
import 'package:javabus/const/api_url.dart' as url;

class BookingService {
  final String apiUrl = '${url.baseUrl}/Booking';

  Future<List<Booking>?> getBookings() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      return null;
    }
  } 

  Future<bool> createBooking(String status, int userId, int scheduleId) async {
    try{
      final response = await http.post(Uri.parse('$apiUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'status': status,
          'userId': userId,
          'scheduleId': scheduleId,
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

  Future<List<Booking>?> getBookingsByUser(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl/user/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Booking.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  Future<bool> updateBooking(int id, String status, int userId, int scheduleId) async {
    try{
      final response = await http.put(Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'status': status,
          'userId': userId,
          'scheduleId': scheduleId,
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

  Future<bool> updateBookingStatus(int bookingId, String status) async {
    try{
      final response = await http.put(
        Uri.parse('$apiUrl/$bookingId/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
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

  Future<bool> deleteBooking(int id) async {
    try{
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
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