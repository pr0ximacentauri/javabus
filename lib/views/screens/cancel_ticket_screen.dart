import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javabus/models/ticket.dart';
import 'package:javabus/models/user.dart';
import 'package:url_launcher/url_launcher.dart';


class CancelTicketScreen extends StatefulWidget {
  final User user;
  final List<Ticket> tickets;

  const CancelTicketScreen({
    super.key,
    required this.user,
    required this.tickets,
  });

  @override
  State<CancelTicketScreen> createState() => _CancelTicketScreenState();
}

class _CancelTicketScreenState extends State<CancelTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  Ticket? selectedTicket;
  String reason = '';

Future<void> _sendToWhatsApp() async {
  final adminPhone = '6282235244931';
  final ticket = selectedTicket;

  if (ticket == null) return;

  final timeFormatted = DateFormat('dd MMM yyyy – HH:mm').format(ticket.departureTime);

  final message = '''
    Halo Admin,
    Saya ${widget.user.fullName} ingin membatalkan tiket berikut:

    🚌 Tiket: ${ticket.originCity} → ${ticket.destinationCity}
    🕒 Keberangkatan: $timeFormatted
    🚍 Bus: ${ticket.busName} (${ticket.busClass})
    💰 Harga: Rp ${ticket.ticketPrice}

    📝 Alasan: $reason

    Mohon dibantu proses pembatalannya. Terima kasih.
    ''';

      final encoded = Uri.encodeComponent(message);
      final url = 'https://wa.me/$adminPhone?text=$encoded';

      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuka WhatsApp')),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembatalan Tiket'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<Ticket>(
                value: selectedTicket,
                items: widget.tickets.map((ticket) {
                  final timeFormatted = DateFormat('dd MMM yyyy – HH:mm').format(ticket.departureTime);
                  return DropdownMenuItem(
                    value: ticket,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7, 
                      child: Text(
                        '${ticket.originCity} → ${ticket.destinationCity} ($timeFormatted)',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTicket = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Pilih Tiket',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null ? 'Silakan pilih tiket' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Alasan Pembatalan',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => reason = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Alasan wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendToWhatsApp();
                  }
                },
                icon: const Icon(Icons.chat),
                label: const Text('Kirim via WhatsApp'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
