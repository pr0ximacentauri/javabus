import 'package:flutter/foundation.dart';
import 'package:javabus/models/booking.dart';
import 'package:javabus/services/booking_service.dart';

class BookingViewModel extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  Booking? newBooking;
  String? error;

  List<Booking>? bookings = [];
  bool isLoading = false;

  Future<void> addBooking(int userId, int scheduleId) async {
    final result = await _bookingService.createBooking(userId, scheduleId);
    if (result != null) {
      newBooking = result;
      error = null;
    } else {
      newBooking = null;
      error = 'Gagal membuat booking.';
    }
    notifyListeners();
  }

  Future<void> fetchBookingsByUser(int userId) async {
    isLoading = true;
    notifyListeners();

    final result = await _bookingService.getBookingsByUser(userId);
    if (result != null) {
      bookings = result;
      error = null;
    } else {
      bookings = [];
      error = 'Gagal memuat data booking.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> updateBookingStatus(int bookingId, String status) async {
    final success = await _bookingService.updateBookingStatus(bookingId, status);
    if (success) {
      final index = bookings!.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        bookings![index] = bookings![index].copyWith(status: status);
        notifyListeners();
      }
      error = null;
      return true;
    } else {
      error = 'Gagal memperbarui status booking.';
      notifyListeners();
      return false;
    }
  }

  bool hasBookingForSchedule(int userId, int scheduleId) {
    return bookings!.any((booking) =>
        booking.userId == userId && booking.scheduleId == scheduleId);
  }
}
