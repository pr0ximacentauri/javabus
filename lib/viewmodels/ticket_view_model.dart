import 'package:flutter/material.dart';
import 'package:javabus/models/ticket.dart';
import 'package:javabus/services/ticket_service.dart';

class TicketViewModel extends ChangeNotifier {
  final TicketService _service = TicketService();

  List<Ticket>? tickets;
  bool isLoading = false;
  String? msg;

  void clearTickets() {
    tickets = [];
    notifyListeners();
  }

  Future<bool> createSnapshot(int bookingId) async {
    final result = await _service.createTicket(bookingId);
    if (!result) {
      msg = "Gagal membuat snapshot";
    }
    return result;
  }

  Future<List<Ticket>?> fetchTicketsByBooking(int bookingId) async {
    isLoading = true;
    notifyListeners();

    final result = await _service.getTicketsByBooking(bookingId);
    if (result != null) {
      tickets = result;
      msg = null;
    } else {
      tickets = null;
      msg = 'Gagal memuat tiket berdasarkan booking';
    }

    notifyListeners();
    return result;
  }

  Future<void> fetchTickets() async {
    isLoading = true;
    notifyListeners();

    final result = await _service.getTickets();
    if (result != null) {
      tickets = result;
      msg = null;
    } else {
      msg = 'Gagal memuat data tiket';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> createTicket(
    int bookingId,
    int seatId,
    String qrCodeUrl,
    DateTime departureTime,
    String originCity,
    String destinationCity,
    String busName,
    String busClass,
    int ticketPrice,
    String ticketStatus,
  ) async {
    final result = await _service.addTicket(bookingId, seatId, qrCodeUrl, departureTime, originCity, destinationCity, busName, busClass, ticketPrice, ticketStatus);

    if (result) {
      await fetchTickets();
      return true;
    } else {
      msg = 'Gagal menambahkan tiket';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTicket(
    int id,
    int bookingId,
    int seatId,
    String qrCodeUrl,
    DateTime departureTime,
    String originCity,
    String destinationCity,
    String busName,
    String busClass,
    int ticketPrice,
    String ticketStatus,
  ) async {
    final result = await _service.updateTicket(id, bookingId, seatId, qrCodeUrl, departureTime, originCity, destinationCity, busName, busClass, ticketPrice, ticketStatus);

    if (result) {
      await fetchTickets();
      return true;
    } else {
      msg = 'Gagal memperbarui tiket';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTicketStatus(int ticketId, String status) async {
    final result = await _service.updateTicketStatus(ticketId, status);
    if (result) {
      await fetchTickets();
      return true;
    } else {
      msg = 'Gagal mengubah status tiket';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTicket(int id) async {
    final result = await _service.deleteTicket(id);
    if (result) {
      await fetchTickets();
      return true;
    } else {
      msg = 'Gagal menghapus tiket';
      notifyListeners();
      return false;
    }
  }
}
