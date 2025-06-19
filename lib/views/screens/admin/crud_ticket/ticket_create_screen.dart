import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:javabus/models/booking.dart';
import 'package:javabus/models/bus_seat.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
import 'package:javabus/viewmodels/bus_view_model.dart';
import 'package:javabus/viewmodels/city_view_model.dart';
import 'package:javabus/viewmodels/route_view_model.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';
import 'package:javabus/viewmodels/seat_selection_view_model.dart';
import 'package:javabus/viewmodels/ticket_view_model.dart';

class TicketCreateScreen extends StatefulWidget {
  const TicketCreateScreen({super.key});

  @override
  State<TicketCreateScreen> createState() => _TicketCreateScreenState();
}

class _TicketCreateScreenState extends State<TicketCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  int? selectedBookingId;
  int? selectedSeatId;
  String selectedStatus = 'belum digunakan';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    Provider.of<BookingViewModel>(context, listen: false).fetchBookings();
    Provider.of<SeatSelectionViewModel>(context, listen: false).fetchBusSeats();
    Provider.of<ScheduleViewModel>(context, listen: false).fetchSchedules();
    Provider.of<BusViewModel>(context, listen: false).fetchBuses();
    Provider.of<RouteViewModel>(context, listen: false).fetchBusRoutes();
    Provider.of<CityViewModel>(context, listen: false).fetchCities();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedBookingId == null || selectedSeatId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking dan Kursi harus dipilih')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
    final scheduleVM = Provider.of<ScheduleViewModel>(context, listen: false);
    final busVM = Provider.of<BusViewModel>(context, listen: false);
    final routeVM = Provider.of<RouteViewModel>(context, listen: false);
    final cityVM = Provider.of<CityViewModel>(context, listen: false);
    final ticketVM = Provider.of<TicketViewModel>(context, listen: false);

    try {
      final booking = bookingVM.bookings.firstWhere((b) => b.id == selectedBookingId);
      final schedule = scheduleVM.schedules.firstWhere((s) => s.id == booking.scheduleId);
      final bus = busVM.buses.firstWhere((b) => b.id == schedule.busId);
      final route = routeVM.busRoutes.firstWhere((r) => r.id == schedule.routeId);
      final origin = cityVM.cities.firstWhere((c) => c.id == route.originCityId);
      final destination = cityVM.cities.firstWhere((c) => c.id == route.destinationCityId);

      final success = await ticketVM.createTicket(
        booking.id,
        selectedSeatId!,
        "-", // qrCodeUrl dummy, backend bisa generate QR
        schedule.departureTime,
        origin.name,
        destination.name,
        bus.name,
        bus.busClass,
        schedule.ticketPrice,
        selectedStatus,
      );

      setState(() => _isSubmitting = false);

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ticketVM.msg ?? 'Gagal membuat tiket')),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data tidak lengkap: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingVM = Provider.of<BookingViewModel>(context);
    final seatVM = Provider.of<SeatSelectionViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tiket')),
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
                    child: Text('Booking ID: ${b.id} - Jadwal: ${b.scheduleId}'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedBookingId = val),
                decoration: const InputDecoration(labelText: 'Pilih Booking'),
                validator: (val) => val == null ? 'Wajib pilih booking' : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<int>(
                value: selectedSeatId,
                items: seatVM.allBusSeats.map((BusSeat seat) {
                  return DropdownMenuItem(
                    value: seat.id,
                    child: Text('Seat ${seat.seatNumber} (ID: ${seat.id})'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedSeatId = val),
                decoration: const InputDecoration(labelText: 'Pilih Kursi'),
                validator: (val) => val == null ? 'Wajib pilih kursi' : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: const [
                  DropdownMenuItem(value: 'belum digunakan', child: Text('Belum Digunakan')),
                  DropdownMenuItem(value: 'selesai', child: Text('Selesai')),
                  DropdownMenuItem(value: 'kadaluwarsa', child: Text('Kadaluwarsa')),
                ],
                onChanged: (val) => setState(() => selectedStatus = val!),
                decoration: const InputDecoration(labelText: 'Status Tiket'),
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
