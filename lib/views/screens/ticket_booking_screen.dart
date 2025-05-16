import 'package:flutter/material.dart';
import 'package:javabus/models/bus.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
import 'package:javabus/viewmodels/payment_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TicketBookingScreen extends StatefulWidget {
  final Bus bus;
  final DateTime departureTime;
  final int scheduleId;
  final int ticketPrice;
  const TicketBookingScreen({super.key, required this.bus, required this.departureTime, required this.scheduleId, required this.ticketPrice});

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  int _selectedTickets = 1;
  late int _availableSeats;

  @override
   void initState() {
    super.initState();
    _availableSeats = widget.bus.totalSeat;
  }
  void _increaseTicket() {
    if (_selectedTickets < _availableSeats) {
      setState(() {
        _selectedTickets++;
      });
    }
  }

  void _decreaseTicket() {
    if (_selectedTickets > 1) {
      setState(() {
        _selectedTickets--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final remainingSeats = _availableSeats - _selectedTickets;

    return Scaffold(
      appBar: AppBar(title: const Text('Pemesanan Tiket')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bus: ${widget.bus.name}", style: const TextStyle(fontSize: 18)),
            Text("Kelas: ${widget.bus.busClass}", style: const TextStyle(fontSize: 16)),
            Text("Keberangkatan: ${widget.departureTime.toLocal()}",
                style: const TextStyle(fontSize: 16)),
            SizedBox(height: 20),

            Text("Jumlah tiket:", style: const TextStyle(fontSize: 16)),
            Row(
              children: [
                IconButton(onPressed: _decreaseTicket, icon: const Icon(Icons.remove)),
                Text(_selectedTickets.toString(), style: const TextStyle(fontSize: 18)),
                IconButton(onPressed: _increaseTicket, icon: const Icon(Icons.add)),
              ],
            ),
            SizedBox(height: 10),
            Text("Sisa kursi setelah dipesan: $remainingSeats", style: const TextStyle(fontSize: 14, color: Colors.grey)),

            const Spacer(),

            ElevatedButton(
              onPressed: () async {
                final authVM = Provider.of<AuthViewModel>(context, listen: false);
                final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
                final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);

                final userId = authVM.user?.id;
                final scheduleId = widget.scheduleId;
                final totalHarga = (_selectedTickets * widget.ticketPrice).toInt();

                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User belum login')),
                  );
                  return;
                }

                print('🎯 Tombol diklik');
                print('👤 User ID: $userId');
                print('📆 Schedule ID: $scheduleId');
                print('💰 Total Harga: $totalHarga');

                // Step 1: Buat booking terlebih dahulu
                await bookingVM.createBooking(userId, scheduleId);

                final booking = bookingVM.newBooking;
                if (booking == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal membuat booking: ${bookingVM.error}')),
                  );
                  return;
                }

                final bookingId = booking.id;
                print('📄 Booking berhasil. ID: $bookingId');

                // Step 2: Lanjut ke pembayaran
                await paymentVM.createPayment(
                  grossAmount: totalHarga,
                  bookingId: bookingId,
                );

                final paymentUrl = paymentVM.paymentUrl;
                if (paymentUrl != null) {
                  final url = Uri.parse(paymentUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tidak bisa membuka halaman pembayaran')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal membuat pembayaran: ${paymentVM.errorMsg}')),
                  );
                }
              },
              child: const Text("Lanjut ke Pembayaran"),
            )

          ],
        )
      )
    );
  }
}