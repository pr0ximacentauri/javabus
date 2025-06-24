// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:javabus/models/booking.dart';
import 'package:javabus/models/ticket.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
import 'package:javabus/viewmodels/ticket_view_model.dart';
import 'package:javabus/views/screens/ticket_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class TicketContent extends StatefulWidget {
  const TicketContent({super.key});

  @override
  State<TicketContent> createState() => _TicketContentState();
}

class _TicketContentState extends State<TicketContent>
    with SingleTickerProviderStateMixin {
  bool isTiketSelected = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      final ticketVM = Provider.of<TicketViewModel>(context, listen: false);
      final bookingVM = Provider.of<BookingViewModel>(context, listen: false);

      final user = authVM.user;
      if (user == null) return;

      await bookingVM.fetchBookingsByUser(user.id);

      final List<Ticket> allFetchedTickets = [];

      for (final booking in bookingVM.bookings) {
        final result = await ticketVM.fetchTicketsByBooking(booking.id);
        if (result != null) {
          allFetchedTickets.addAll(result);
        }
      }

      ticketVM.setTickets(allFetchedTickets);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ticketVM = Provider.of<TicketViewModel>(context);
    final bookingVM = Provider.of<BookingViewModel>(context);
    final now = DateTime.now();

    final allTickets = ticketVM.tickets;
    final allBookings = bookingVM.bookings;

    final filtered = allTickets.where((ticket) {
      final booking = allBookings.firstWhere(
        (b) => b.id == ticket.bookingId,
        orElse: () => Booking(id: 0, userId: 0, scheduleId: 0, status: 'unknown'),
      );

      if (isTiketSelected) {
        return booking.status == 'lunas' &&
            ticket.ticketStatus == 'belum digunakan' &&
            ticket.departureTime.isAfter(now);
      }

      if (ticket.ticketStatus == 'selesai' || ticket.ticketStatus == 'kadaluwarsa') {
        return true;
      }

      if (ticket.ticketStatus == 'belum digunakan' &&
          ticket.departureTime.isBefore(now)) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await ticketVM.updateTicketStatus(ticket.id, 'kadaluwarsa');
        });
        return true;
      }

      return false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade600,
        title: const Text(
          'Tiket Perjalanan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.amber, Colors.deepOrange]),
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
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _controller.value * 2 * math.pi,
                              child: Icon(Icons.receipt_long,
                                  size: 80, color: Colors.amber.shade400),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text("Loading...",
                            style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final ticket = filtered[index];
                      final booking = allBookings.firstWhere(
                        (b) => b.id == ticket.bookingId,
                        orElse: () => Booking(id: 0, userId: 0, scheduleId: 0, status: 'unknown'),
                      );
                      return buildTicketCard(booking, ticket, context);
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
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))]
                : null,
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
      case 'belum digunakan':
        chipColor = Colors.green;
        break;
      case 'selesai':
        chipColor = Colors.blue;
        break;
      case 'kadaluwarsa':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        border: Border.all(color: chipColor),
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

  Widget buildTicketCard(Booking booking, Ticket ticket, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.amber.shade50, Colors.white]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (ticket.ticketStatus.toLowerCase() == 'kadaluwarsa' ||
                ticket.ticketStatus.toLowerCase() == 'selesai') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tiket ${ticket.ticketStatus.toLowerCase()}'),
                  backgroundColor: Colors.orange.shade600,
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketDetailScreen(ticket: ticket),
                ),
              );
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
                        gradient: const LinearGradient(colors: [Colors.amber, Colors.orange]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('ID: ${booking.id}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    _buildStatusChip(ticket.ticketStatus),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.amber.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(ticket.departureTime),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700]),
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
                      'Rp ${NumberFormat('#,###').format(ticket.ticketPrice)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber.shade800),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
