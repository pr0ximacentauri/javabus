import 'package:flutter/foundation.dart';
import 'package:javabus/models/booking.dart';
import 'package:javabus/models/schedule.dart';
import 'package:javabus/services/booking_service.dart';
import 'package:javabus/services/schedule_service.dart';

class BookingWithSchedule {
  final Booking booking;
  final Schedule schedule;

  BookingWithSchedule({
    required this.booking,
    required this.schedule,
  });
}

class BookingViewModel extends ChangeNotifier {
  final BookingService _bookingService = BookingService();
  final ScheduleService _scheduleService = ScheduleService();

  Booking? newBooking;
  String? error;

  List<BookingWithSchedule> bookingsWithSchedules = [];
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

  Future<void> fetchBookingsWithSchedules(int userId) async {
    isLoading = true;
    notifyListeners();

    final bookings = await _bookingService.getBookingsByUser(userId);
    bookingsWithSchedules = [];

    if (bookings != null) {
      for (var booking in bookings) {
        final schedule = await _scheduleService.getScheduleById(booking.scheduleId);
        if (schedule != null) {
          bookingsWithSchedules.add(BookingWithSchedule(
            booking: booking,
            schedule: schedule,
          ));
        }
      }
      error = null;
    } else {
      error = 'Gagal memuat data booking.';
    }

    isLoading = false;
    notifyListeners();
  }

  bool hasBookingForSchedule(int userId, int scheduleId) {
    return bookingsWithSchedules.any((bws) =>
        bws.booking.userId == userId &&
        bws.booking.scheduleId == scheduleId);
  }


  Future<bool> updateBookingStatus(int bookingId, String status) async {
    final success = await _bookingService.updateBookingStatus(bookingId, status);
    if (success) {
      final index = bookingsWithSchedules.indexWhere((bws) => bws.booking.id == bookingId);
      if (index != -1) {
        final oldBws = bookingsWithSchedules[index];
        final updatedBooking = oldBws.booking.copyWith(status: status);
        bookingsWithSchedules[index] = BookingWithSchedule(
          booking: updatedBooking,
          schedule: oldBws.schedule,
        );
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
}
