import 'package:flutter/material.dart';
import 'package:javabus/models/booking.dart';
import 'package:javabus/models/schedule.dart';
import 'package:javabus/models/bus_seat.dart';
import 'package:javabus/models/seat_booking.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';
import 'package:javabus/viewmodels/seat_selection_view_model.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class SeatBookingUpdateScreen extends StatefulWidget {
  final SeatBooking seatBooking;

  const SeatBookingUpdateScreen({super.key, required this.seatBooking});

  @override
  State<SeatBookingUpdateScreen> createState() => _SeatBookingUpdateScreenState();
}

class _SeatBookingUpdateScreenState extends State<SeatBookingUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  Booking? _selectedBooking;
  Schedule? _selectedSchedule;
  BusSeat? _selectedSeat;

  @override
  void initState() {
    super.initState();
    final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
    final scheduleVM = Provider.of<ScheduleViewModel>(context, listen: false);
    final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);

    bookingVM.fetchBookings();
    scheduleVM.fetchSchedules();
    seatVM.fetchBusSeats();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final b = bookingVM.bookings.firstWhereOrNull((b) => b.id == widget.seatBooking.bookingId);
      final s = scheduleVM.schedules.firstWhereOrNull((s) => s.id == widget.seatBooking.scheduleId);
      final seat = seatVM.allBusSeats.firstWhereOrNull((seat) => seat.id == widget.seatBooking.seatId);

      setState(() {
        _selectedBooking = b;
        _selectedSchedule = s;
        _selectedSeat = seat;
      });
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedBooking == null || _selectedSchedule == null || _selectedSeat == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua field harus dipilih')),
        );
        return;
      }

      setState(() => _isSubmitting = true);

      final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);
      final success = await seatVM.updateSeatBooking(
        widget.seatBooking.id,
        _selectedSchedule!.id,
        _selectedSeat!.id,
        _selectedBooking!.id,
      );

      setState(() => _isSubmitting = false);

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(seatVM.msg ?? 'Gagal memperbarui data kursi')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingVM = Provider.of<BookingViewModel>(context);
    final scheduleVM = Provider.of<ScheduleViewModel>(context);
    final seatVM = Provider.of<SeatSelectionViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Seat Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<Booking>(
                value: _selectedBooking,
                items: bookingVM.bookings.map((Booking b) {
                  return DropdownMenuItem(
                    value: b,
                    child: Text('Booking ID: ${b.id} - User: ${b.userId}'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedBooking = val),
                decoration: const InputDecoration(labelText: 'Booking'),
                validator: (val) => val == null ? 'Pilih booking' : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<Schedule>(
                value: _selectedSchedule,
                items: scheduleVM.schedules.map((Schedule s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text('Schedule ID: ${s.id} - ${s.departureTime}'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedSchedule = val),
                decoration: const InputDecoration(labelText: 'Jadwal'),
                validator: (val) => val == null ? 'Pilih jadwal' : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<BusSeat>(
                value: _selectedSeat,
                items: seatVM.allBusSeats.map((BusSeat seat) {
                  return DropdownMenuItem(
                    value: seat,
                    child: Text('Seat ${seat.seatNumber} (ID: ${seat.id})'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedSeat = val),
                decoration: const InputDecoration(labelText: 'Kursi'),
                validator: (val) => val == null ? 'Pilih kursi' : null,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
