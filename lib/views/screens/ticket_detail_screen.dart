import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javabus/models/ticket.dart';
import 'package:javabus/viewmodels/payment_view_model.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailScreen extends StatefulWidget {
  final Ticket ticket;

  const TicketDetailScreen({super.key, required this.ticket});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  @override
  void initState() {
    super.initState();
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
    paymentVM.fetchPaymentByBookingId(widget.ticket.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tiket'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: QrImageView(
                data: ticket.qrCodeUrl.isNotEmpty ? ticket.qrCodeUrl : ticket.id.toString(),
                version: QrVersions.auto,
                size: 200,
              ),
            ),
            const SizedBox(height: 20),
            Text('ID Tiket: ${ticket.id}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              'Keberangkatan: ${DateFormat('dd MMM yyyy, HH:mm').format(ticket.departureTime)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text('Asal: ${ticket.originCity} → Tujuan: ${ticket.destinationCity}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Bus: ${ticket.busName} (${ticket.busClass})', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Harga: Rp ${NumberFormat('#,###').format(ticket.ticketPrice)}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Status Tiket: ${ticket.ticketStatus}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            Consumer<PaymentViewModel>(
              builder: (context, paymentVM, _) {
                final payment = paymentVM.payment;
                if (payment == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(thickness: 1),
                    const SizedBox(height: 10),
                    const Text('Detail Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Order ID: ${payment.orderId}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Metode: ${payment.paymentType}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Total Bayar: Rp ${NumberFormat('#,###').format(payment.grossAmount)}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Status Pembayaran: ${payment.transactionStatus}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Waktu Transaksi: ${DateFormat('dd MMM yyyy, HH:mm').format(payment.transactionTime)}', style: const TextStyle(fontSize: 16)),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
