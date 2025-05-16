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

  Future<void> createBooking(int userId, int scheduleId) async {
    try {
      newBooking = await _bookingService.createBooking(userId, scheduleId);
      error = null;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      newBooking = null;
      notifyListeners();
    }
  }

  Future<void> fetchBookingsWithSchedules(int userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final bookings = await _bookingService.getBookingsByUser(userId);
      bookingsWithSchedules = [];

      for (var booking in bookings) {
        final schedule = await _scheduleService.getScheduleById(booking.scheduleId);
        bookingsWithSchedules.add(BookingWithSchedule(booking: booking, schedule: schedule));
      }

      error = null;
    } catch (e) {
      error = e.toString();
      bookingsWithSchedules = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
