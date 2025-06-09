import 'package:flutter/material.dart';
import 'package:javabus/models/city.dart';
import 'package:provider/provider.dart';
import 'package:javabus/viewmodels/route_view_model.dart';
import 'package:javabus/viewmodels/city_view_model.dart';

class RouteSelectionScreen extends StatefulWidget {
  final bool isOriginSelection;
  const RouteSelectionScreen({super.key, required this.isOriginSelection});

  @override
  State<RouteSelectionScreen> createState() => _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends State<RouteSelectionScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cityVM = Provider.of<CityViewModel>(context, listen: false);
      if (cityVM.cities.isEmpty) {
        cityVM.fetchCities();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final cityVM = Provider.of<CityViewModel>(context);
    final routeVM = Provider.of<RouteViewModel>(context);

    final filteredCities = cityVM.searchCities(_searchQuery);

    final provinceGroups = <String, List<City>>{};
    for (var city in filteredCities) {
      final provinceName = _capitalize(city.province?.name ?? 'Tanpa Provinsi');
      provinceGroups.putIfAbsent(provinceName, () => []);
      provinceGroups[provinceName]!.add(city);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isOriginSelection ? 'Pilih Kota Asal' : 'Pilih Kota Tujuan'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Cari kota atau provinsi',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: cityVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provinceGroups.isEmpty
                    ? const Center(child: Text('Data tidak ditemukan'))
                    : ListView(
                        children: provinceGroups.entries.map((entry) {
                          return ExpansionTile(
                            title: Text(entry.key),
                            children: entry.value.map((city) {
                              return ListTile(
                                title: Text(_capitalize(city.name)),
                                onTap: () {
                                  if (widget.isOriginSelection) {
                                    routeVM.selectedOrigin = city;
                                    routeVM.selectedDestination = null;
                                  } else {
                                    routeVM.selectedDestination = city;
                                  }
                                  routeVM.notifyListeners();
                                  Navigator.pop(context);
                                },
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
