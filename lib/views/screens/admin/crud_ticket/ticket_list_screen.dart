import 'package:flutter/material.dart';
import 'package:javabus/models/ticket.dart';
import 'package:javabus/viewmodels/ticket_view_model.dart';
import 'package:javabus/views/screens/admin/crud_ticket/ticket_create_screen.dart';
import 'package:javabus/views/screens/admin/crud_ticket/ticket_update_screen.dart';
import 'package:provider/provider.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketViewModel>(context, listen: false).fetchTickets();
    });
  }

  void _navigateToCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TicketCreateScreen()),
    );
  }

  void _navigateToUpdate(Ticket ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TicketUpdateScreen(ticket: ticket)),
    );
  }

  void _delete(int id) async {
    final ticketVM = Provider.of<TicketViewModel>(context, listen: false);
    final success = await ticketVM.deleteTicket(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Tiket dihapus' : 'Gagal menghapus tiket')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketViewModel>(
      builder: (context, ticketVM, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Data Tiket Penumpang'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _navigateToCreate,
              ),
            ],
          ),
          body: ticketVM.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ticketVM.msg != null
                  ? Center(child: Text(ticketVM.msg!))
                  : ListView.builder(
                      itemCount: ticketVM.tickets.length,
                      itemBuilder: (context, index) {
                        final ticket = ticketVM.tickets[index];
                        return ListTile(
                            title: Text('Booking ID: ${ticket.bookingId}, Seat ID: ${ticket.seatId}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Harga Tiket: Rp${ticket.ticketPrice}'),
                                Text('Status: ${ticket.ticketStatus}'),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _navigateToUpdate(ticket);
                                } else if (value == 'delete') {
                                  _delete(ticket.id);
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
