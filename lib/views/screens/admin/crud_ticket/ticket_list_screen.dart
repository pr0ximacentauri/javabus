import 'package:flutter/material.dart';
import 'package:javabus/models/bus_seat.dart';
import 'package:javabus/viewmodels/seat_selection_view_model.dart';
import 'package:javabus/viewmodels/ticket_view_model.dart';
import 'package:javabus/views/screens/admin/crud_bus_seat/bus_seat_create_screen.dart';
import 'package:javabus/views/screens/admin/crud_bus_seat/bus_seat_update_screen.dart';
import 'package:provider/provider.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<TicketListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketViewModel>(context, listen: false).fetchTickets();
    });
  }

  void _navigateToCreate() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BusSeatCreateScreen()));
  }

  void _navigateToUpdate(BusSeat seat) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BusSeatUpdateScreen(seat: seat)));
  }

  void _delete(int id) async {
    final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);
    final success = await seatVM.deleteBusSeat(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Kursi bus dihapus' : 'Gagal hapus kursi bus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SeatSelectionViewModel>(
      builder: (context, seatVM, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Data Kursi Bus'),
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
                      itemCount: seatVM.allBusSeats.length,
                      itemBuilder: (context, index) {
                        final seat = seatVM.allBusSeats[index];
                        return ListTile(
                          title: Text('Nomor Kursi: ${seat.seatNumber}, ID Bus: ${seat.busId}'),
                          subtitle: Text('ID: ${seat.id}'),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _navigateToUpdate(seat);
                              } else if (value == 'delete') {
                                _delete(seat.id);
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
