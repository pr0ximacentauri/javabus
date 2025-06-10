// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
import 'package:javabus/viewmodels/payment_view_model.dart';
import 'package:javabus/views/widgets/payment_webview.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TicketContent extends StatefulWidget {
  final int? selectedBookingId;
  const TicketContent({super.key, this.selectedBookingId});

  @override
  State<TicketContent> createState() => _TicketContentState();
}

class _TicketContentState extends State<TicketContent> {
  bool isTiketSelected = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<AuthViewModel>(context, listen: false).user!.id;
      // print("Fetching bookings for userId: $userId"); 
      Provider.of<BookingViewModel>(context, listen: false)
          .fetchBookingsWithSchedules(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingVM = Provider.of<BookingViewModel>(context);
    final List<BookingWithSchedule> bookingsWithSchedules = bookingVM.bookingsWithSchedules;
    final filtered = bookingsWithSchedules.where((bws) =>
      isTiketSelected
        ? (bws.booking.status == 'belum digunakan' || bws.booking.status == 'pending')
        : (bws.booking.status != 'belum digunakan' && bws.booking.status != 'pending')
    ).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade600,
        title: const Text('Tiket Perjalanan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: bookingVM.isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber, Colors.deepOrange],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildFilterToggle(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text("Tidak ada tiket", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final bws = filtered[index];
                      final booking = bws.booking;
                      final schedule = bws.schedule;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.amber.shade50, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () async {
                              if (booking.status.toLowerCase() == 'pending') {
                                final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
                                final bookingVM = Provider.of<BookingViewModel>(context, listen: false);

                                final totalHarga = schedule.ticketPrice;

                                await paymentVM.addPayment(
                                  grossAmount: totalHarga,
                                  bookingId: booking.id,
                                );

                                final paymentUrl = paymentVM.paymentUrl;

                                if (paymentUrl != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentWebView(url: paymentUrl),
                                    ),
                                  );

                                  await bookingVM.updateBookingStatus(booking.id, 'belum digunakan');

                                  final userId = Provider.of<AuthViewModel>(context, listen: false).user!.id;
                                  await bookingVM.fetchBookingsWithSchedules(userId);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Pembayaran selesai, status tiket diperbarui.')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Gagal membuat pembayaran: ${paymentVM.errorMsg}')),
                                  );
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Colors.amber, Colors.orange],
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'ID: ${booking.id}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      _buildStatusChip(booking.status),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(Icons.schedule, color: Colors.amber.shade700, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          DateFormat('dd MMM yyyy, HH:mm').format(schedule.departureTime),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(Icons.payments, color: Colors.amber.shade700, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Rp ${NumberFormat('#,###').format(schedule.ticketPrice)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (booking.status.toLowerCase() == 'pending') ...[
                                    const SizedBox(height: 16),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Colors.amber, Colors.orange],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Tap untuk bayar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildTab('Tiket', true),
          _buildTab('Riwayat', false),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool selected) {
    final isSelected = selected == isTiketSelected;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isTiketSelected = selected),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.amber.shade700 : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'belum digunakan':
        chipColor = Colors.green;
        break;
      default:
        chipColor = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        border: Border.all(color: chipColor, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: chipColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}