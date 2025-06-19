import 'package:flutter/material.dart';
import 'package:javabus/models/bus.dart';
import 'package:javabus/viewmodels/bus_view_model.dart';
import 'package:provider/provider.dart';

class BusCatalogScreen extends StatefulWidget {
  const BusCatalogScreen({super.key});

  @override
  State<BusCatalogScreen> createState() => _BusCatalogScreenState();
}

class _BusCatalogScreenState extends State<BusCatalogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BusViewModel>(context, listen: false).fetchBuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusViewModel>(
      builder: (context, busVM, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Daftar Bus"),
          ),
          body: busVM.isLoading
              ? const Center(child: CircularProgressIndicator())
              : busVM.msg != null
                  ? Center(child: Text(busVM.msg!))
                  : ListView.builder(
                      itemCount: busVM.buses.length,
                      itemBuilder: (context, index) {
                        final Bus bus = busVM.buses[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _capitalize(bus.name),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text("Kelas: ${_capitalize(bus.busClass)}", style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 4),
                                Text("Jumlah Kursi: ${bus.totalSeat}", style: const TextStyle(fontSize: 14)),
                                if (bus.id != null)
                                  Text("Bus ID: ${bus.id}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }

  String _capitalize(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
