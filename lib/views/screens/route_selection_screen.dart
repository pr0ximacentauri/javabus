import 'package:flutter/material.dart';
import 'package:javabus/models/city.dart';
import 'package:provider/provider.dart';
import 'package:javabus/viewmodels/route_view_model.dart';

class RouteSelectionScreen extends StatelessWidget {
  final bool isOriginSelection;
  const RouteSelectionScreen({super.key, required this.isOriginSelection});

  @override
  Widget build(BuildContext context) {
    final routeVM = Provider.of<RouteViewModel>(context);
    final List<City> cities = isOriginSelection ? routeVM.origins : routeVM.destinations;

    return Scaffold(
      appBar: AppBar(
        title: Text(isOriginSelection ? 'Pilih Kota Asal' : 'Pilih Kota Tujuan'),
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          return ListTile(
            title: Text(city.name),
            onTap: () {
              if (isOriginSelection) {
                routeVM.selectedOrigin = city;
                routeVM.selectedDestination = null;
              } else {
                routeVM.selectedDestination = city;
              }
              routeVM.notifyListeners();
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}