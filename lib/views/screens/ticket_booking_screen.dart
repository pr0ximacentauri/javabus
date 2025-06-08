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

  const TicketBookingScreen({super.key, required this.bus, required this.departureTime, required this.scheduleId, required this.ticketPrice});

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  List<int> selectedSeatIds = [];

  @override
   void initState() {
    super.initState();
    final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);
    seatVM.LoadBusSeats(widget.bus.id, widget.scheduleId); 
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Pemesanan Tiket')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bus: ${widget.bus.name}", style: const TextStyle(fontSize: 18)),
            Text("Kelas: ${widget.bus.busClass}", style: const TextStyle(fontSize: 16)),
            Text("Keberangkatan: ${widget.departureTime.toLocal()}", style: const TextStyle(fontSize: 16)),
            SizedBox(height: 20),

            Text("Pilih Kursi", style: const TextStyle(fontSize: 16)),
            
            Expanded(
              child: Consumer<SeatSelectionViewModel>(
                builder: (context, seatVM, child) {
                  final seats = seatVM.allBusSeats;
                  if (seats.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: seats.map((seat){
                        final isBooked = seatVM.isSeatBooked(seat.id);
                        final isSelected = selectedSeatIds.contains(seat.id);

                        return GestureDetector(
                          onTap: isBooked ? null : () {
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
                            decoration: BoxDecoration(
                              color: isBooked ? Colors.grey : isSelected ? Colors.green : Colors.blue,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(seat.seatNumber.toString()),
                          ),
                        );
                      }).toList(),
                    )
                  );
                }
              )
            ),
            SizedBox(height: 10),
            Text("Total: ${selectedSeatIds.length} tiket (Rp ${selectedSeatIds.length * widget.ticketPrice})", style: const TextStyle(fontSize: 16)),

            SizedBox(height: 10),
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

                if(selectedSeatIds.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pilih minimal satu kursi')),
                  );
                  return;
                }

                if (bookingVM.hasBookingForSchedule(userId, scheduleId)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tiket ini sudah dipesan')),
                  );
                  return;
                }

                // print('🎯 Tombol diklik');
                // print('👤 User ID: $userId');
                // print('📆 Schedule ID: $scheduleId');
                // print('💰 Total Harga: $totalPrice');

                await bookingVM.addBooking(userId, scheduleId);
                
                final booking = bookingVM.newBooking;
                if (booking == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal membuat booking: ${bookingVM.error}')),
                  );
                  return;
                }

                final bookingId = booking.id;
                print('📄 Booking berhasil. ID: $bookingId');

                for (final seatId in selectedSeatIds) {
                  await seatVM.addSeatBooking(
                    scheduleId,
                    seatId,
                    bookingId,
                  );
                }

                final totalPrice = selectedSeatIds.length * widget.ticketPrice;

                await paymentVM.addPayment(
                  grossAmount: totalPrice,
                  bookingId: bookingId,
                );

                final paymentUrl = paymentVM.paymentUrl;
                if (paymentUrl != null) {
                  final snapshotSuccess = await ticketVM.createSnapshot(bookingId);
                  if(snapshotSuccess){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(ticketVM.Msg ?? 'Gagal membuat tiket'))
                    );
                    return;
                  }
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentWebView(url: paymentUrl),
                    ),
                  );

                  await bookingVM.updateBookingStatus(booking.id, 'belum digunakan');
                  await bookingVM.fetchBookingsWithSchedules(userId);
                  await seatVM.LoadBusSeats(widget.bus.id, widget.scheduleId);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pembayaran selesai, kursi berhasil dipesan')),
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
        )
      )
    );
  }
}