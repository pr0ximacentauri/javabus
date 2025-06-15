import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';
import 'package:javabus/viewmodels/seat_selection_view_model.dart';
import 'package:javabus/models/booking.dart';
import 'package:javabus/models/schedule.dart';
import 'package:javabus/models/bus_seat.dart';

class SeatBookingCreateScreen extends StatefulWidget {
  const SeatBookingCreateScreen({super.key});

  @override
  State<SeatBookingCreateScreen> createState() => _SeatBookingCreateScreenState();
}

class _SeatBookingCreateScreenState extends State<SeatBookingCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  int? selectedScheduleId;
  int? selectedBookingId;
  int? selectedSeatId;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final scheduleVM = Provider.of<ScheduleViewModel>(context, listen: false);
    final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
    final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);

    scheduleVM.fetchSchedules();
    bookingVM.fetchBookings();
    seatVM.fetchBusSeats(); 
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (selectedScheduleId == null || selectedSeatId == null || selectedBookingId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua field harus diisi')),
        );
        return;
      }

      setState(() => _isSubmitting = true);

      final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);
      final success = await seatVM.addSeatBooking(selectedScheduleId!, selectedBookingId!, selectedSeatId!);

      setState(() => _isSubmitting = false);

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(seatVM.msg ?? 'Gagal menambahkan seat booking')),
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
      appBar: AppBar(title: const Text('Tambah Seat Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: selectedBookingId,
                items: bookingVM.bookings.map((Booking b) {
                  return DropdownMenuItem(
                    value: b.id,
                    child: Text('Booking ID: ${b.id} - User: ${b.userId}'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedBookingId = val),
                decoration: const InputDecoration(labelText: 'Booking'),
                validator: (val) => val == null ? 'Pilih booking' : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<int>(
                value: selectedScheduleId,
                items: scheduleVM.schedules.map((Schedule s) {
                  return DropdownMenuItem(
                    value: s.id,
                    child: Text('Schedule ID: ${s.id} - ${s.departureTime}'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedScheduleId = val),
                decoration: const InputDecoration(labelText: 'Jadwal'),
                validator: (val) => val == null ? 'Pilih jadwal' : null,
              ),
              const SizedBox(height: 12),

              // Dropdown Seat
              DropdownButtonFormField<int>(
                value: selectedSeatId,
                items: seatVM.allBusSeats.map((BusSeat seat) {
                  return DropdownMenuItem(
                    value: seat.id,
                    child: Text('Seat ${seat.seatNumber} (ID: ${seat.id})'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedSeatId = val),
                decoration: const InputDecoration(labelText: 'Nomor Kursi'),
                validator: (val) => val == null ? 'Pilih kursi' : null,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
