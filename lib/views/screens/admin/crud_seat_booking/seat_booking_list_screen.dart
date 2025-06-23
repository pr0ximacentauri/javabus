import 'package:flutter/material.dart';
import 'package:javabus/models/seat_booking.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';
import 'package:javabus/viewmodels/seat_selection_view_model.dart';
import 'package:javabus/views/screens/admin/crud_seat_booking/seat_booking_create_screen.dart';
import 'package:javabus/views/screens/admin/crud_seat_booking/seat_booking_update_screen.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class SeatBookingListScreen extends StatefulWidget {
  const SeatBookingListScreen({super.key});

  @override
  State<SeatBookingListScreen> createState() => _SeatBookingListScreenState();
}

class _SeatBookingListScreenState extends State<SeatBookingListScreen> {
  @override
  void initState() {
    super.initState();
    final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
    final scheduleVM = Provider.of<ScheduleViewModel>(context, listen: false);
    final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bookingVM.fetchBookings();
      scheduleVM.fetchSchedules();
      seatVM.fetchSeatBookings();
      seatVM.fetchBusSeats();
    });
  }

  void _navigateToCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SeatBookingCreateScreen()),
    );
  }

  void _navigateToUpdate(SeatBooking seatBooking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeatBookingUpdateScreen(seatBooking: seatBooking),
      ),
    );
  }

  void _delete(int id) async {
    final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);
    final success = await seatVM.deleteSeatBooking(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Seat Booking dihapus' : 'Gagal hapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<SeatSelectionViewModel, BookingViewModel, ScheduleViewModel>(
      builder: (context, seatVM, bookingVM, scheduleVM, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Data Seat Booking'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _navigateToCreate,
              ),
            ],
          ),
          body: seatVM.isLoading
              ? const Center(child: CircularProgressIndicator())
              : seatVM.msg != null
                  ? Center(child: Text(seatVM.msg!))
                  : ListView.builder(
                      itemCount: seatVM.seatBookingsBySchedule.length,
                      itemBuilder: (context, index) {
                        final seatBooking = seatVM.seatBookingsBySchedule[index];
                        final booking = bookingVM.bookings.firstWhereOrNull((b) => b.id == seatBooking.bookingId);
                        final seat = seatVM.allBusSeats.firstWhereOrNull((s) => s.id == seatBooking.seatId);
                        final schedule = scheduleVM.schedules.firstWhereOrNull((s) => s.id == booking?.scheduleId);

                        return ListTile(
                          title: Text('Booking ID: ${booking?.id ?? '-'}, User: ${booking?.userId ?? '-'}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Seat Number: ${seat?.seatNumber ?? '-'}'),
                              Text('Departure: ${schedule?.departureTime.toString() ?? '-'}'),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _navigateToUpdate(seatBooking);
                              } else if (value == 'delete') {
                                _delete(seatBooking.id);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'edit', child: Text('Update')),
                              PopupMenuItem(value: 'delete', child: Text('Delete')),
                            ],
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
