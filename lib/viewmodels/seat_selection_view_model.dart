import 'package:flutter/material.dart';
import 'package:javabus/models/bus_seat.dart';
import 'package:javabus/services/bus_seat_service.dart';
import 'package:javabus/services/seat_booking_service.dart';

class SeatSelectionViewModel extends ChangeNotifier{
  final BusSeatService _seatService;
  final SeatBookingService _seatBookingService;

  List<BusSeat> allBusSeats = [];
  List<int> bookedSeats = [];
  BusSeat? newBusSeat;

  String? msg;
  bool isLoading = false;

  SeatSelectionViewModel(this._seatService, this._seatBookingService);

  Future<void> LoadBusSeats(int busId, int scheduleId) async {
    final seats = await _seatService.getBusSeatsByBus(busId);
    allBusSeats = seats ?? [];
    final bookings = await _seatBookingService.getSeatBookingSchedules(scheduleId);
    bookedSeats = bookings?.map((e) => e.seatId).toList() ?? [];

    notifyListeners();
  }


  bool isSeatBooked(int seatId){
    return bookedSeats.contains(seatId);
  }

  Future<bool> addSeatBooking(int scheduleId, int seatId, int bookingId) async{
    final result = await _seatBookingService.createSeatBooking(scheduleId, seatId, bookingId);
    if(result != null){
      bookedSeats.add(seatId);
      notifyListeners();
      return true;
    }else{
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
      msg = 'Gagal menghapus bus';
      notifyListeners();
      return false;
    }
  }
}