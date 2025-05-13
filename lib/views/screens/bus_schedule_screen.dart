import 'package:flutter/material.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';
import 'package:provider/provider.dart';

class BusScheduleScreen extends StatelessWidget {
  const BusScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleVM = Provider.of<ScheduleViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Bus")),
      body: scheduleVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : scheduleVM.msg != null
              ? Center(child: Text("Terjadi kesalahan: ${scheduleVM.msg ?? 'Tidak diketahui'}"))
              : ListView.builder(
        itemCount: scheduleVM.schedules.length,
        itemBuilder: (context, index) {
          final schedule = scheduleVM.schedules[index];
          return ListTile(
            leading: SizedBox(
              height: 80,
              width: 80,
              child: Image.asset(
                'assets/ijen.jpg',
                fit: BoxFit.contain,
              ),
            ),
            title: Text("Jam: ${schedule.departureTime.hour}:${schedule.departureTime.minute.toString().padLeft(2, '0')}"),
            subtitle: Text("Harga: Rp${schedule.ticketPrice}"),
            trailing: ElevatedButton.icon(
              onPressed: (){},  
              icon: const Icon(Icons.money, color: Colors.black,),
              label: const Text("Beli Tiket", style: TextStyle(color: Colors.black),),
            ),
          );
        },
      ),
    );
  }
}