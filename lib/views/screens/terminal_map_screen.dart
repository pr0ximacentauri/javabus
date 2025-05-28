// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:javabus/views/widgets/navbar.dart';
import 'package:latlong2/latlong.dart';

class TerminalMapScreen extends StatelessWidget {
  const TerminalMapScreen({super.key});

  @override

  Widget build(BuildContext context) {
    return Navbar();
  }
}

class TerminalMapContent extends StatefulWidget {
  const TerminalMapContent({super.key});

  @override
  State<TerminalMapContent> createState() => _TerminalMapContentState();
}

class _TerminalMapContentState extends State<TerminalMapContent> {
  LatLng? _currentLocation;
  final MapController _mapController = MapController();
  bool _isLoadingLocation = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _errorMessage = 'Layanan lokasi dinonaktifkan. Mohon aktifkan layanan lokasi.';
        _isLoadingLocation = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _errorMessage = 'Izin lokasi ditolak. Anda tidak akan bisa melihat lokasi Anda di peta.';
          _isLoadingLocation = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _errorMessage = 'Izin lokasi ditolak secara permanen. Kami tidak dapat meminta izin.';
        _isLoadingLocation = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });
      
      if (_currentLocation != null) {
        _mapController.move(_currentLocation!, 15.0); 
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mendapatkan lokasi: ${e.toString()}';
        _isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Lokasi'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoadingLocation
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                )
              : _currentLocation == null
                  ? const Center(
                      child: Text('Tidak dapat mengambil lokasi. Pastikan izin telah diberikan.'),
                    )
                  : FlutterMap(
                      options: MapOptions(
                        initialCenter: _currentLocation!,
                        initialZoom: 15.0, 
                        minZoom: 2.0,
                        maxZoom: 18.0,
                      ),
                      mapController: _mapController,
                      children: [
                        TileLayer(
                          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                          userAgentPackageName: 'com.example.javabus',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _currentLocation!,
                              width: 80.0,
                              height: 80.0,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isLoadingLocation = true;
            _errorMessage = '';
          });
          _determinePosition();
        },
        child: const Icon(Icons.my_location),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}