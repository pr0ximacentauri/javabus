import 'package:flutter/foundation.dart';
import 'package:javabus/models/booking.dart';
import 'package:javabus/services/booking_service.dart';

class BookingViewModel extends ChangeNotifier {
  final BookingService _service = BookingService();

  List<Booking> bookings = [];
  
  String? msg;
  bool isLoading = false;

  Future<void> fetchBookings() async {
    isLoading = true;
    notifyListeners();

    final result = await _service.getBookings();
    if (result != null) {
      bookings = result;
      msg = null;
    } else {
      msg = 'Gagal memuat data bus';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> createBooking(String status, int userId, int scheduleId) async {
    final success = await _service.createBooking(status, userId, scheduleId);
    if (success) {
      fetchBookings;
      return true;
    } else {
      msg = 'Gagal membuat booking.';
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchBookingsByUser(int userId) async {
    isLoading = true;
    notifyListeners();

    final result = await _service.getBookingsByUser(userId);
    if (result != null) {
      bookings = result;
      msg = null;
    } else {
      bookings = [];
      msg = 'Gagal memuat data booking.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> updateBookingStatus(int bookingId, String status) async {
    final success = await _service.updateBookingStatus(bookingId, status);
    if (success) {
      final index = bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        bookings[index] = bookings[index].copyWith(status: status);
        notifyListeners();
      }
      msg = null;
      return true;
    } else {
      msg = 'Gagal memperbarui status booking.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBooking(int id, String status, int userId, int scheduleId) async {
    final success = await _service.updateBooking(id, status, userId, scheduleId);
    if (success) {
      fetchBookings;
      return true;
    } else {
      msg = 'Gagal memperbarui booking.';
      notifyListeners();
      return false;
    }
  }

    Future<bool> deleteBooking(int id)  async {
    final success = await _service.deleteBooking(id);

    if (success) {
      await fetchBookings();
      return true;
    }else{
      msg = 'Gagal hapus booking';
      notifyListeners();
      return false;
    }
  }
}
