import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:javabus/models/city.dart';
import 'package:javabus/viewmodels/terminal_view_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TerminalNearestScreen extends StatefulWidget {
  const TerminalNearestScreen({super.key});

  @override
  State<TerminalNearestScreen> createState() => _TerminalNearestScreenState();
}

class _TerminalNearestScreenState extends State<TerminalNearestScreen> {
  List<LatLng> routePoints = [];
  City? nearestTerminal;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => findNearestAndRoute());
  }

  Future<void> findNearestAndRoute() async {
    final vm = Provider.of<TerminalViewModel>(context, listen: false);

    if (vm.currentLocation == null || vm.terminals == null || vm.terminals!.isEmpty) return;

    final distance = const Distance();
    final userLocation = vm.currentLocation!;

    nearestTerminal = vm.terminals!.reduce((a, b) {
      final dA = distance(userLocation, LatLng(a.latitude, a.longitude));
      final dB = distance(userLocation, LatLng(b.latitude, b.longitude));
      return dA < dB ? a : b;
    });

    final terminalLocation = LatLng(nearestTerminal!.latitude, nearestTerminal!.longitude);

    final url =
        "http://router.project-osrm.org/route/v1/driving/${userLocation.longitude},${userLocation.latitude};${terminalLocation.longitude},${terminalLocation.latitude}?overview=full&geometries=geojson";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coords = data['routes'][0]['geometry']['coordinates'] as List;
      setState(() {
        routePoints = coords.map((point) => LatLng(point[1], point[0])).toList();
      });
    } else {
      debugPrint("Gagal mengambil rute: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TerminalViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Terminal Terdekat"),
        backgroundColor: Colors.amber,
      ),
      body: Builder(
        builder: (context) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());

          if (vm.errorMessage.isNotEmpty) return Center(child: Text(vm.errorMessage));

          if (vm.currentLocation == null || nearestTerminal == null) {
            return const Center(child: Text("Data tidak tersedia."));
          }

          return FlutterMap(
            options: MapOptions(
              initialCenter: vm.currentLocation!,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.javabus',
              ),
              PolylineLayer(
                polylines: [
                  if (routePoints.isNotEmpty)
                    Polyline(
                      points: routePoints,
                      strokeWidth: 5,
                      color: Colors.blueAccent,
                    ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: vm.currentLocation!,
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.person_pin_circle, color: Colors.red, size: 40),
                  ),
                  Marker(
                    point: LatLng(nearestTerminal!.latitude, nearestTerminal!.longitude),
                    width: 50,
                    height: 50,
                    child: Tooltip(
                      message: nearestTerminal!.name,
                      child: const Icon(Icons.directions_bus, color: Colors.green, size: 35),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
