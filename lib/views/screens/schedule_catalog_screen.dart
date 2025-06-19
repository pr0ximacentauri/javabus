import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javabus/models/schedule.dart';
import 'package:javabus/viewmodels/route_view_model.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';
import 'package:provider/provider.dart';

class ScheduleCatalogScreen extends StatefulWidget {
  const ScheduleCatalogScreen({super.key});

  @override
  State<ScheduleCatalogScreen> createState() => _ScheduleCatalogScreenState();
}

class _ScheduleCatalogScreenState extends State<ScheduleCatalogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScheduleViewModel>(context, listen: false).fetchSchedules();
      Provider.of<RouteViewModel>(context, listen: false).fetchBusRoutes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Bus')),
      body: Consumer2<ScheduleViewModel, RouteViewModel>(
        builder: (context, scheduleVM, routeVM, _) {
          if (scheduleVM.isLoading || routeVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (scheduleVM.msg != null) {
            return Center(child: Text('Error: ${scheduleVM.msg!}'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: scheduleVM.schedules.length,
            itemBuilder: (context, index) {
              final Schedule schedule = scheduleVM.schedules[index];
              final route = routeVM.busRoutes.firstWhereOrNull(
                (r) => r.id == schedule.routeId
              );

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Keberangkatan: ${DateFormat('dd MMM yyyy – HH:mm').format(schedule.departureTime)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Harga Tiket: Rp${schedule.ticketPrice}'),
                      Text('ID Bus: ${schedule.busId}'),
                      if (route != null)
                        Text('Rute: ${route.originCityId} → ${route.destinationCityId}')
                      else
                        const Text('Rute: Tidak ditemukan', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
