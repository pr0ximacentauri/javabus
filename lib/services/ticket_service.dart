import 'dart:convert';
import 'package:javabus/const/api_url.dart' as url;
import 'package:http/http.dart' as http;
import 'package:javabus/models/ticket.dart';

class TicketService{
  final String apiUrl = '${url.baseUrl}/Ticket';

  Future<bool> createTicket(int bookingId) async {
    try{
      final response = await http.post(Uri.parse('$apiUrl/snapshot/$bookingId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  Future<List<Ticket>?> getTicketsByBooking(int bookingId) async {
    final response = await http.get(Uri.parse('$apiUrl/booking/$bookingId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Ticket.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<List<Ticket>?> getTickets() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Ticket.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<Ticket?> getById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Ticket.fromJson(data);
    } else {
      return null;
    }
  }

  Future<bool> addTicket(int bookingId, int seatId, String qrCodeUrl, DateTime departureTime, String originCity, String destinationCity, String busName, String busClass, int ticketPrice, String ticketStatus) async {
    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'bookingId': bookingId,
            'seatId': seatId,
            'qrCodeUrl': qrCodeUrl,
            'departureTime': departureTime.toIso8601String(),
            'originCity': originCity,
            'destinationCity': destinationCity,
            'busName': busName,
            'busClass': busClass,
            'ticketPrice': ticketPrice,
            'ticketStatus': ticketStatus,
          }
        ),
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

  Future<bool> updateTicket(int id, int bookingId, int seatId, String qrCodeUrl, DateTime departureTime, String originCity, String destinationCity, String busName, String busClass, int ticketPrice, String ticketStatus) async {
    try{
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'bookingId': bookingId,
            'seatId': seatId,
            'qrCodeUrl': qrCodeUrl,
            'departureTime': departureTime.toIso8601String(),
            'originCity': originCity,
            'destinationCity': destinationCity,
            'busName': busName,
            'busClass': busClass,
            'ticketPrice': ticketPrice,
            'ticketStatus': ticketStatus,
          }
        ),
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

  Future<bool> updateTicketStatus(int id, String status) async {
    try{
      final response = await http.patch(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(status),
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

  Future<bool> deleteTicket(int id) async {
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