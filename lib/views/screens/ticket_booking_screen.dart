import 'package:flutter/material.dart';
import 'package:javabus/models/bus.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
import 'package:javabus/viewmodels/payment_view_model.dart';
import 'package:javabus/viewmodels/seat_selection_view_model.dart';
import 'package:javabus/viewmodels/ticket_view_model.dart';
import 'package:javabus/views/widgets/payment_webview.dart';
import 'package:provider/provider.dart';

class TicketBookingScreen extends StatefulWidget {
  final Bus bus;
  final DateTime departureTime;
  final int scheduleId;
  final int ticketPrice;

  const TicketBookingScreen({
    super.key,
    required this.bus,
    required this.departureTime,
    required this.scheduleId,
    required this.ticketPrice,
  });

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  List<int> selectedSeatIds = [];

  @override
  void initState() {
    super.initState();
    final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);
    seatVM.LoadBusSeats(widget.bus.id!, widget.scheduleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pemesanan Tiket')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bus: ${widget.bus.name}", style: const TextStyle(fontSize: 18)),
            Text("Kelas: ${widget.bus.busClass}", style: const TextStyle(fontSize: 16)),
            Text("Keberangkatan: ${widget.departureTime.toLocal()}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text("Pilih Kursi", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            _buildSeatLegend(),
            const SizedBox(height: 10),

            Expanded(
              child: Consumer<SeatSelectionViewModel>(
                builder: (context, seatVM, child) {
                  final seats = seatVM.allBusSeats;
                  if (seats.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final groupedSeats = <String, List<dynamic>>{};
                  for (final seat in seats) {
                    final rowLabel = seat.seatNumber.substring(0, 1);
                    groupedSeats.putIfAbsent(rowLabel, () => []).add(seat);
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: groupedSeats.entries.map((entry) {
                        final rowSeats = entry.value;
                        rowSeats.sort((a, b) => a.seatNumber.compareTo(b.seatNumber));

                        final leftSeats = rowSeats.sublist(0, rowSeats.length ~/ 2);
                        final rightSeats = rowSeats.sublist(rowSeats.length ~/ 2);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...leftSeats.map((seat) => _buildSeatWidget(seat)),
                              const SizedBox(width: 32),
                              ...rightSeats.map((seat) => _buildSeatWidget(seat)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            Text(
              "Total: ${selectedSeatIds.length} tiket (Rp ${selectedSeatIds.length * widget.ticketPrice})",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                final authVM = Provider.of<AuthViewModel>(context, listen: false);
                final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
                final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
                final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);
                final ticketVM = Provider.of<TicketViewModel>(context, listen: false);

                final userId = authVM.user?.id;
                final scheduleId = widget.scheduleId;

                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User belum login')),
                  );
                  return;
                }

                if (selectedSeatIds.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pilih minimal satu kursi')),
                  );
                  return;
                }

                if (widget.departureTime.isBefore(DateTime.now().add(const Duration(hours: 1)))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pemesanan ditutup kurang dari 1 jam sebelum keberangkatan')),
                  );
                  return;
                }

                await bookingVM.addBooking(userId, scheduleId);
                final booking = bookingVM.newBooking;

                if (booking == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal membuat booking: ${bookingVM.error}')),
                  );
                  return;
                }

                final bookingId = booking.id;
                bool seatBookingSuccess = true;

                for (final seatId in selectedSeatIds) {
                  final success = await seatVM.addSeatBooking(scheduleId, seatId, bookingId);
                  if (!success) seatBookingSuccess = false;
                }

                if (!seatBookingSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sebagian kursi gagal dipesan')),
                  );
                  return;
                }

                final totalPrice = selectedSeatIds.length * widget.ticketPrice;
                await paymentVM.addPayment(grossAmount: totalPrice, bookingId: bookingId);

                final paymentUrl = paymentVM.paymentUrl;
                if (paymentUrl != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentWebView(url: paymentUrl),
                    ),
                  );

                  await bookingVM.updateBookingStatus(booking.id, 'belum digunakan');
                  await bookingVM.fetchBookingsWithSchedules(userId);
                  await seatVM.LoadBusSeats(widget.bus.id!, widget.scheduleId);

                  final snapshotSuccess = await ticketVM.createSnapshot(bookingId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        snapshotSuccess
                            ? 'Tiket berhasil dibuat'
                            : ticketVM.msg ?? 'Gagal membuat tiket',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal membuat pembayaran: ${paymentVM.errorMsg}')),
                  );
                }
              },
              child: const Text("Lanjut ke Pembayaran"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSeatWidget(seat) {
    final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);
    final isBooked = seatVM.isSeatBooked(seat.id);
    final isSelected = selectedSeatIds.contains(seat.id);

    return GestureDetector(
      onTap: isBooked
          ? null
          : () {
              setState(() {
                if (isSelected) {
                  selectedSeatIds.remove(seat.id);
                } else {
                  selectedSeatIds.add(seat.id);
                }
              });
            },
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isBooked
              ? Colors.grey
              : isSelected
                  ? Colors.green
                  : Colors.blue,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(seat.seatNumber),
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _LegendBox(color: Colors.blue, label: 'Tersedia'),
        SizedBox(width: 10),
        _LegendBox(color: Colors.green, label: 'Dipilih'),
        SizedBox(width: 10),
        _LegendBox(color: Colors.grey, label: 'Terisi'),
      ],
    );
  }
}

class _LegendBox extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendBox({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, border: Border.all(), borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
