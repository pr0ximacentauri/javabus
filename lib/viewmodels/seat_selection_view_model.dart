import 'package:flutter/material.dart';
import 'package:javabus/models/bus_seat.dart';
import 'package:javabus/models/seat_booking.dart';
import 'package:javabus/services/bus_seat_service.dart';
import 'package:javabus/services/seat_booking_service.dart';

class SeatSelectionViewModel extends ChangeNotifier{
  final BusSeatService _seatService;
  final SeatBookingService _seatBookingService;

  List<BusSeat> allBusSeats = [];
  List<SeatBooking> seatBookingsBySchedule = [];

  String? msg;
  bool isLoading = false;

  SeatSelectionViewModel(this._seatService, this._seatBookingService);
  Future<void> loadBusSeats(int busId, int scheduleId) async {
    allBusSeats = await _seatService.getBusSeatsByBus(busId) ?? [];
    seatBookingsBySchedule = await _seatBookingService.getSeatBookingSchedules(scheduleId) ?? [];
    notifyListeners();
  }



  Future<void> fetchSeatBookings() async {
    isLoading = true;
    notifyListeners();

    final result = await _seatBookingService.getSeatBookings();
    if (result != null) {
      seatBookingsBySchedule = result;
      msg = null;
    } else {
      msg = 'Gagal memuat data bus';
    }

    isLoading = false;
    notifyListeners();
  }

  bool isSeatBooked(int seatId) {
    return seatBookingsBySchedule.any((b) => b.seatId == seatId);
  }


  Future<bool> addSeatBooking(int bookingId, int scheduleId, int seatId) async {
    final result = await _seatBookingService.createSeatBooking(bookingId, scheduleId, seatId);
    if (result) {
      seatBookingsBySchedule.add(
        SeatBooking(
          id: 0,
          bookingId: bookingId,
          scheduleId: scheduleId,
          seatId: seatId,
        ),
      );
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }


  Future<bool> updateSeatBooking(int id, int bookingId, int scheduleId, int newSeatId) async {
    final result = await _seatBookingService.updateSeatBooking(id, bookingId, scheduleId, newSeatId);
    if (result) {
      final index = seatBookingsBySchedule.indexWhere((sb) => sb.id == id);
      if (index != -1) {
        seatBookingsBySchedule[index] = SeatBooking(
          id: id,
          bookingId: bookingId,
          scheduleId: scheduleId,
          seatId: newSeatId,
        );
        notifyListeners();
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteSeatBooking(int id) async {
    final result = await _seatBookingService.deleteSeatBooking(id);
    if (result) {
      seatBookingsBySchedule.removeWhere((booking) => booking.id == id);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }


  Future<void> fetchBusSeats() async {
    isLoading = true;
    notifyListeners();

    final result = await _seatService.getBusSeats();
    if (result != null) {
      allBusSeats = result;
      msg = null;
    } else {
      msg = 'Gagal memuat data kursi bus';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<BusSeat?> getBusSeatById(int id) async {
    final seat = await _seatService.getById(id);
    if (seat == null) {
      msg = 'Kursi dengan ID $id tidak ditemukan';
      notifyListeners();
    }
    return seat;
  }

  Future<bool> createBusSeat(String seatNumber, int busId) async {
    final result = await _seatService.createBusSeat(seatNumber, busId);
    if (result) {
      await fetchBusSeats();
      return true;
    } else {
      msg = 'Gagal menambahkan kursi bus';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBusSeat(int id, String seatNumber, int busId) async {
    final result = await _seatService.updateBusSeat(id, seatNumber, busId);
    if (result) {
      await fetchBusSeats();
      return true;
    } else {
      msg = 'Gagal memperbarui kursi bus';
      notifyListeners();
      return false;
    }
  }


  Future<bool> deleteBusSeat(int id) async {
    final result = await _seatService.deleteBusSeat(id);
    if (result) {
      await fetchBusSeats();
      return true;
    } else {
      msg = 'Gagal menghapus kursi bus';
      notifyListeners();
      return false;
    }
  }
}