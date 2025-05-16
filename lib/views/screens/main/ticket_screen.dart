import 'package:flutter/material.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
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
    final userId = Provider.of<AuthViewModel>(context, listen: false).user!.id;
    Provider.of<BookingViewModel>(context, listen: false).fetchBookingsWithSchedules(userId);
  }

  @override
  Widget build(BuildContext context) {
    final bookingVM = Provider.of<BookingViewModel>(context);
    final List<BookingWithSchedule> bookingsWithSchedules = bookingVM.bookingsWithSchedules;
    final filtered = bookingsWithSchedules.where((bws) =>
      isTiketSelected ? bws.booking.status == 'Belum Digunakan' : bws.booking.status != 'Belum Digunakan'
    ).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Tiket Perjalanan'), backgroundColor: Colors.white),
      body: bookingVM.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 16),
          _buildFilterToggle(),
          const SizedBox(height: 16),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("Tidak ada data"))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final bws = filtered[index];
                      final booking = bws.booking;
                      final schedule = bws.schedule;

                      return Card(
                        margin: const EdgeInsets.all(12),
                        child: ListTile(
                          title: Text('Booking ID: ${booking.id}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Status: ${booking.status}'),
                              Text('Tanggal Keberangkatan: ${DateFormat('dd MMM yyyy, HH:mm').format(schedule.departureTime)}'),
                              Text('Harga Tiket: Rp ${schedule.ticketPrice}'),
                              // Jika ada informasi route, bisa ditampilkan (misal asal - tujuan)
                              // Text('Rute: ${schedule.route.origin} - ${schedule.route.destination}'),
                            ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _buildTab('Tiket', true),
            _buildTab('Riwayat', false),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool selected) {
    final isSelected = selected == isTiketSelected;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isTiketSelected = selected),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.orangeAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
