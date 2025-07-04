import 'package:flutter/material.dart';
import 'package:javabus/models/bus_route.dart';
import 'package:javabus/viewmodels/city_view_model.dart';
import 'package:javabus/viewmodels/route_view_model.dart';
import 'package:javabus/views/screens/admin/crud_bus_route/bus_route_create_screen.dart';
import 'package:javabus/views/screens/admin/crud_bus_route/bus_route_update_screen.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class BusRouteListScreen extends StatefulWidget {
  const BusRouteListScreen({super.key});

  @override
  State<BusRouteListScreen> createState() => _BusRouteListScreenState();
}

class _BusRouteListScreenState extends State<BusRouteListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RouteViewModel>(context, listen: false).fetchBusRoutes();
      Provider.of<CityViewModel>(context, listen: false).fetchCities();
    });
  }

  void _navigateToCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BusRouteCreateScreen()),
    );
  }

  void _navigateToUpdate(BusRoute busRoute) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BusRouteUpdateScreen(busRoute: busRoute)),
    );
  }

  void _delete(int id) async {
    final routeVM = Provider.of<RouteViewModel>(context, listen: false);
    final success = await routeVM.deleteBusRoute(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Rute bus dihapus' : 'Gagal hapus rute bus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RouteViewModel, CityViewModel>(
      builder: (context, routeVM, cityVM, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Data Rute Bus'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _navigateToCreate,
              ),
            ],
          ),
          body: routeVM.isLoading || cityVM.isLoading
              ? const Center(child: CircularProgressIndicator())
              : routeVM.msg != null
                  ? Center(child: Text(routeVM.msg!))
                  : ListView.builder(
                      itemCount: routeVM.busRoutes.length,
                      itemBuilder: (context, index) {
                        final route = routeVM.busRoutes[index];
                        final originCity = cityVM.cities.firstWhereOrNull(
                            (city) => city.id == route.originCityId);
                        final destCity = cityVM.cities.firstWhereOrNull(
                            (city) => city.id == route.destinationCityId);

                        return ListTile(
                          title: Text(
                            'Asal: ${originCity?.name ?? "?"} - Tujuan: ${destCity?.name ?? "?"}',
                          ),
                          subtitle: Text('ID Rute: ${route.id}'),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _navigateToUpdate(route);
                              } else if (value == 'delete') {
                                _delete(route.id!);
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
