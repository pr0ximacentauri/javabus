import 'package:flutter/material.dart';
import 'package:javabus/models/bus_seat.dart';
import 'package:javabus/services/bus_seat_service.dart';
import 'package:javabus/services/seat_booking_service.dart';

class SeatSelectionViewModel extends ChangeNotifier{
  final BusSeatService seatService;
  final SeatBookingService seatBookingService;

  List<BusSeat>? allBusSeats = [];
  List<int> bookedSeats = [];

  SeatSelectionViewModel(this.seatService, this.seatBookingService);

  Future<void> LoadBusSeats(int busId, int scheduleId) async{
    allBusSeats = await seatService.getBusSeats(busId);
    final bookings = await seatBookingService.getSeatBookingSchedules(scheduleId);
    bookedSeats = bookings!.map((e) => e.seatId).toList();
    notifyListeners();    
  }

  bool isSeatBooked(int seatId){
    return bookedSeats.contains(seatId);
  }

  Future<bool> addSeatBooking(int scheduleId, int seatId, int bookingId) async{
    final result = await seatBookingService.createSeatBooking(scheduleId, seatId, bookingId);
    if(result != null){
      bookedSeats.add(seatId);
      notifyListeners();
      return true;
    }else{
      return false;
    }
  }
}