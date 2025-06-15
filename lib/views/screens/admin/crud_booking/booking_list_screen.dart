import 'package:flutter/material.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
import 'package:javabus/views/screens/admin/crud_booking/booking_create_screen.dart';
import 'package:javabus/views/screens/admin/crud_booking/booking_update_screen.dart';
import 'package:provider/provider.dart';
import 'package:javabus/models/booking.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingViewModel>(context, listen: false).fetchBookings();
    });
  }

  void _navigateToCreate() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingCreateScreen()));
  }

  void _navigateToUpdate(Booking booking) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BookingUpdateScreen(booking: booking)));
  }

  void _delete(int id) async {
    final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
    final success = await bookingVM.deleteBooking(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Booking dihapus' : 'Gagal hapus booking')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Data Booking Tiket'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _navigateToCreate,
              ),
            ],
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.msg != null
                  ? Center(child: Text(viewModel.msg!))
                  : ListView.builder(
                      itemCount: viewModel.bookings.length,
                      itemBuilder: (context, index) {
                        final booking = viewModel.bookings[index];
                        return ListTile(
                          title: Text('ID Jadwal: ${booking.scheduleId} (ID User: ${booking.userId})'),
                          subtitle: Text('ID: ${booking.id}'),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _navigateToUpdate(booking);
                              } else if (value == 'delete') {
                                _delete(booking.id);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'edit', child: Text('Update')),
                              const PopupMenuItem(value: 'delete', child: Text('Delete')),
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
