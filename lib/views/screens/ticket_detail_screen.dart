import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javabus/models/ticket.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailScreen extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tiket'), backgroundColor: Colors.amber),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            QrImageView(
              data: ticket.qrCodeUrl ?? 'No QR Code',
              version: QrVersions.auto,
              size: 200,
            ),
            const SizedBox(height: 20),
            Text('ID Tiket: ${ticket.id}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              'Keberangkatan: ${DateFormat('dd MMM yyyy, HH:mm').format(ticket.departureTime)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text('Asal: ${ticket.originCity} → Tujuan: ${ticket.destinationCity}',style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Bus: ${ticket.busName} (${ticket.busClass})', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Harga: Rp ${NumberFormat('#,###').format(ticket.ticketPrice)}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Status: ${ticket.ticketStatus}', style: const TextStyle(fontSize: 16)),
          ],
        )
      )
    );
  }
}