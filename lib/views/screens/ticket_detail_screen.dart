// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javabus/models/ticket.dart';
import 'package:javabus/models/bus_seat.dart';
import 'package:javabus/viewmodels/payment_view_model.dart';
import 'package:javabus/viewmodels/seat_selection_view_model.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailScreen extends StatefulWidget {
  final Ticket ticket;

  const TicketDetailScreen({super.key, required this.ticket});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  BusSeat? seat;
  bool isLoadingSeat = true;

  @override
  void initState() {
    super.initState();

    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
    final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);

    paymentVM.fetchPaymentByBookingId(widget.ticket.bookingId);
    _loadSeat(seatVM);
  }

  Future<void> _loadSeat(SeatSelectionViewModel seatVM) async {
    final result = await seatVM.getBusSeatById(widget.ticket.seatId);
    if (!mounted) return; 
    setState(() {
      seat = result;
      isLoadingSeat = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Detail Tiket', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade200),
                          ),
                          child: QrImageView(
                            data: ticket.qrCodeUrl.isNotEmpty
                                ? ticket.qrCodeUrl
                                : ticket.id.toString(),
                            version: QrVersions.auto,
                            size: 180,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Consumer<PaymentViewModel>(
                          builder: (context, paymentVM, _) {
                            final payment = paymentVM.payment;
                            return Text(
                              payment?.orderId ?? 'Loading...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                                letterSpacing: 1.2,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomPaint(
                      painter: DashedLinePainter(),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Route
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _capitalize(ticket.originCity),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    
                                  ),
                                  Text(
                                    DateFormat('dd MMM yyyy').format(ticket.departureTime),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.amber,
                                size: 24,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _capitalize(ticket.destinationCity),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('HH:mm').format(ticket.departureTime),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailItem(
                                'Bus',
                                '${_capitalize(ticket.busName)}',
                                Icons.directions_bus,
                              ),
                            ),
                            Expanded(
                              child: isLoadingSeat
                                  ? _buildDetailItem(
                                      'Kursi/Kelas', 'Loading...',
                                      Icons.event_seat,
                                    )
                                  : _buildDetailItem(
                                      'Kursi/Kelas', '${seat?.seatNumber} / ${_capitalize(ticket.busClass)}',
                                      Icons.event_seat,
                                    ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailItem(
                                'Harga', 'Rp ${NumberFormat('#,###').format(ticket.ticketPrice)}',
                                Icons.payment,
                              ),
                            ),
                            Expanded(
                              child: _buildDetailItem(
                                'Status', _capitalize(ticket.ticketStatus),
                                Icons.check_circle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Payment Info Card
            Consumer<PaymentViewModel>(
              builder: (context, paymentVM, _) {
                final payment = paymentVM.payment;
                if (payment == null) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.receipt, color: Colors.amber, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Informasi Pembayaran',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildPaymentRow('Metode Pembayaran', _capitalize(payment.paymentType)),
                        _buildPaymentRow('Status Pembayaran', _capitalize(payment.transactionStatus)),
                        _buildPaymentRow('Waktu Transaksi', DateFormat('dd MMM yyyy, HH:mm').format(payment.transactionTime)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.amber.shade700, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

String _capitalize(String text) {
  return text.split(' ').map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    const dashWidth = 5;
    const dashSpace = 5;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}