import 'package:flutter/material.dart';
import 'package:javabus/models/bus_route.dart';
import 'package:javabus/models/schedule.dart';
import 'package:javabus/viewmodels/route_view_model.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';
import 'package:javabus/views/screens/admin/crud_bus_route/bus_route_create_screen.dart';
import 'package:javabus/views/screens/admin/crud_bus_route/bus_route_update_screen.dart';
import 'package:javabus/views/screens/admin/crud_schedule/schedule_create_screen.dart';
import 'package:javabus/views/screens/admin/crud_schedule/schedule_update_screen.dart';
import 'package:provider/provider.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScheduleViewModel>(context, listen: false).fetchSchedules();
    });
  }

  void _navigateToCreate() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduleCreateScreen()));
  }

  void _navigateToUpdate(Schedule schedule) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleUpdateScreen(schedule: schedule)));
  }

  void _delete(int id) async {
    final scheduleVM = Provider.of<RouteViewModel>(context, listen: false);
    final success = await scheduleVM.deleteBusRoute(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Jadwal bus dihapus' : 'Gagal hapus jadwal bus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleViewModel>(
      builder: (context, scheduleVM, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Data Jadwal Bus'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _navigateToCreate,
              ),
            ],
          ),
          body: scheduleVM.isLoading
              ? const Center(child: CircularProgressIndicator())
              : scheduleVM.msg != null
                  ? Center(child: Text(scheduleVM.msg!))
                  : ListView.builder(
                      itemCount: scheduleVM.schedules.length,
                      itemBuilder: (context, index) {
                        final schedule = scheduleVM.schedules[index];
                        return ListTile(
                          title: Text('Tanggal Keberangkatan: ${schedule.departureTime} - harga Tiket: ${schedule.ticketPrice}'),
                          subtitle: Text('(ID: ${schedule.id}) ID Bus: ${schedule.busId} - ID Rute: ${schedule.routeId}'),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _navigateToUpdate(schedule);
                              } else if (value == 'delete') {
                                _delete(schedule.id);
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
