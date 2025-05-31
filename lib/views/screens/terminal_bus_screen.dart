import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:javabus/viewmodels/terminal_view_model.dart';
import 'package:javabus/views/widgets/navbar.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class TerminalBusScreen extends StatelessWidget {
  const TerminalBusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navbar();
  }
}

class TerminalBusContent extends StatelessWidget {
  const TerminalBusContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TerminalViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Terminal Bus'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  viewModel.errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (viewModel.currentLocation == null) {
            return const Center(child: Text('Lokasi tidak tersedia.'));
          }

          return FlutterMap(
            options: MapOptions(
              initialCenter: viewModel.currentLocation!,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.javabus',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: viewModel.currentLocation!,
                    width: 80.0,
                    height: 80.0,
                    child: const Icon(Icons.person_pin_circle, color: Colors.red, size: 40.0),
                  ),
                  ...viewModel.terminals!.map((terminal) => Marker(
                        point: LatLng(terminal.latitude, terminal.longitude),
                        width: 60,
                        height: 60,
                        child: Tooltip(
                          message: terminal.name,
                          child: const Icon(Icons.directions_bus, color: Colors.green, size: 35),
                        ),
                      )),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.refreshLocation(),
        child: const Icon(Icons.my_location),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
