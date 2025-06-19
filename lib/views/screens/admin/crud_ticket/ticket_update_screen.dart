import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javabus/models/ticket.dart';
import 'package:javabus/models/booking.dart';
import 'package:javabus/models/bus_seat.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
import 'package:javabus/viewmodels/seat_selection_view_model.dart';
import 'package:javabus/viewmodels/ticket_view_model.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class TicketUpdateScreen extends StatefulWidget {
  final Ticket ticket;

  const TicketUpdateScreen({super.key, required this.ticket});

  @override
  State<TicketUpdateScreen> createState() => _TicketUpdateScreenState();
}

class _TicketUpdateScreenState extends State<TicketUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  late TextEditingController qrCodeController;
  late TextEditingController originController;
  late TextEditingController destinationController;
  late TextEditingController busNameController;
  late TextEditingController busClassController;
  late TextEditingController priceController;
  late DateTime departureTime;

  Booking? _selectedBooking;
  BusSeat? _selectedSeat;
  String selectedStatus = 'belum digunakan';

  @override
  void initState() {
    super.initState();

    final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
    final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);

    bookingVM.fetchBookings();
    seatVM.fetchBusSeats();

    qrCodeController = TextEditingController(text: widget.ticket.qrCodeUrl);
    originController = TextEditingController(text: widget.ticket.originCity);
    destinationController = TextEditingController(text: widget.ticket.destinationCity);
    busNameController = TextEditingController(text: widget.ticket.busName);
    busClassController = TextEditingController(text: widget.ticket.busClass);
    priceController = TextEditingController(text: widget.ticket.ticketPrice.toString());
    departureTime = widget.ticket.departureTime;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final booking = bookingVM.bookings.firstWhereOrNull((b) => b.id == widget.ticket.bookingId);
      final seat = seatVM.allBusSeats.firstWhereOrNull((s) => s.id == widget.ticket.seatId);
      setState(() {
        _selectedBooking = booking;
        _selectedSeat = seat;
        selectedStatus = widget.ticket.ticketStatus;
      });
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedBooking == null || _selectedSeat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking dan kursi harus dipilih')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final ticketVM = Provider.of<TicketViewModel>(context, listen: false);
    final success = await ticketVM.updateTicket(
      widget.ticket.id,
      _selectedBooking!.id,
      _selectedSeat!.id,
      qrCodeController.text,
      departureTime,
      originController.text,
      destinationController.text,
      busNameController.text,
      busClassController.text,
      int.tryParse(priceController.text) ?? 0,
      selectedStatus,
    );

    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ticketVM.msg ?? 'Gagal memperbarui tiket')),
      );
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: departureTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(departureTime),
    );
    if (time == null) return;

    setState(() {
      departureTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingVM = Provider.of<BookingViewModel>(context);
    final seatVM = Provider.of<SeatSelectionViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Tiket')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Booking>(
                value: _selectedBooking,
                items: bookingVM.bookings.map((b) {
                  return DropdownMenuItem(
                    value: b,
                    child: Text('Booking ID: ${b.id}'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedBooking = val),
                decoration: const InputDecoration(labelText: 'Booking'),
                validator: (val) => val == null ? 'Pilih booking' : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<BusSeat>(
                value: _selectedSeat,
                items: seatVM.allBusSeats.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text('Seat ${s.seatNumber} (ID: ${s.id})'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedSeat = val),
                decoration: const InputDecoration(labelText: 'Kursi'),
                validator: (val) => val == null ? 'Pilih kursi' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: qrCodeController,
                decoration: const InputDecoration(labelText: 'QR Code URL'),
                validator: (val) => val == null || val.isEmpty ? 'QR Code wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              ListTile(
                title: Text('Waktu Berangkat: ${DateFormat.yMd().add_Hm().format(departureTime)}'),
                trailing: const Icon(Icons.edit),
                onTap: _pickDateTime,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: originController,
                decoration: const InputDecoration(labelText: 'Kota Asal'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: destinationController,
                decoration: const InputDecoration(labelText: 'Kota Tujuan'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: busNameController,
                decoration: const InputDecoration(labelText: 'Nama Bus'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: busClassController,
                decoration: const InputDecoration(labelText: 'Kelas Bus'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga Tiket'),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Status Tiket'),
                items: const [
                  DropdownMenuItem(value: 'belum digunakan', child: Text('Belum Digunakan')),
                  DropdownMenuItem(value: 'selesai', child: Text('Selesai')),
                  DropdownMenuItem(value: 'kadaluwarsa', child: Text('Kadaluwarsa')),
                ],
                onChanged: (val) => setState(() => selectedStatus = val!),
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
