import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javabus/viewmodels/bus_view_model.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';
import 'package:javabus/views/screens/ticket_booking_screen.dart';
import 'package:provider/provider.dart';

class BusScheduleScreen extends StatelessWidget {
  const BusScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleVM = Provider.of<ScheduleViewModel>(context);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Bus")),
      body: scheduleVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : scheduleVM.msg != null
              ? Center(child: Text("Terjadi kesalahan: ${scheduleVM.msg!}"))
              : ListView.builder(
                  itemCount: scheduleVM.schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = scheduleVM.schedules[index];
                    final departure = schedule.departureTime;
                    final isExpired = departure.isBefore(now.add(const Duration(hours: 1)));

                    return Opacity(
                      opacity: isExpired ? 0.5 : 1.0,
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Image.asset('assets/javabus-logo.png', fit: BoxFit.contain),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Waktu Berangkat: ${DateFormat('dd MMM yyyy, HH:mm').format(departure)}",
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text("Harga: Rp${schedule.ticketPrice}", style: const TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isExpired ? Colors.grey : Colors.yellow,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  onPressed: isExpired
                                      ? null
                                      : () async {
                                          final bus = await Provider.of<BusViewModel>(context, listen: false)
                                              .getBusById(schedule.busId);
                                          if (bus != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => TicketBookingScreen(
                                                  bus: bus,
                                                  departureTime: schedule.departureTime,
                                                  scheduleId: schedule.id,
                                                  ticketPrice: schedule.ticketPrice,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  icon: const Icon(Icons.money),
                                  label: Text(isExpired ? "Tidak Tersedia" : "Beli Tiket"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
