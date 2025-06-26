import 'package:flutter/material.dart';
import 'package:javabus/models/bus_route.dart';
import 'package:javabus/models/city.dart';
import 'package:javabus/viewmodels/city_view_model.dart';
import 'package:javabus/viewmodels/route_view_model.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class BusRouteUpdateScreen extends StatefulWidget {
  final BusRoute busRoute;

  const BusRouteUpdateScreen({super.key, required this.busRoute});

  @override
  State<BusRouteUpdateScreen> createState() => _BusRouteUpdateScreenState();
}

class _BusRouteUpdateScreenState extends State<BusRouteUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  City? _selectedOrigin;
  City? _selectedDestination;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cityVM = Provider.of<CityViewModel>(context, listen: false);
      await cityVM.fetchCities();

      final origin = cityVM.cities.firstWhereOrNull((c) => c.id == widget.busRoute.originCityId);
      final destination = cityVM.cities.firstWhereOrNull((c) => c.id == widget.busRoute.destinationCityId);

      setState(() {
        _selectedOrigin = origin;
        _selectedDestination = destination;
      });
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedOrigin == null || _selectedDestination == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kota asal dan tujuan harus dipilih')),
        );
        return;
      }

      if (_selectedOrigin!.id == _selectedDestination!.id) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kota asal dan tujuan tidak boleh sama')),
        );
        return;
      }

      final routeVM = Provider.of<RouteViewModel>(context, listen: false);
      final isDuplicate = routeVM.busRoutes.any((r) =>
          r.originCityId == _selectedOrigin!.id &&
          r.destinationCityId == _selectedDestination!.id &&
          r.id != widget.busRoute.id);

      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rute ini sudah ada')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final success = await routeVM.updateBusRoute(
        widget.busRoute.id!,
        _selectedOrigin!.id,
        _selectedDestination!.id,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(routeVM.msg ?? 'Gagal memperbarui rute')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CityViewModel>(
      builder: (context, cityVM, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Edit Rute Bus')),
          body: cityVM.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<City>(
                          value: _selectedOrigin,
                          items: cityVM.cities
                              .map((city) => DropdownMenuItem(
                                    value: city,
                                    child: Text(city.name),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            _selectedOrigin = value;
                          }),
                          decoration: const InputDecoration(labelText: 'Kota Asal'),
                          validator: (value) =>
                              value == null ? 'Pilih kota asal' : null,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<City>(
                          value: _selectedDestination,
                          items: cityVM.cities
                              .map((city) => DropdownMenuItem(
                                    value: city,
                                    child: Text(city.name),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            _selectedDestination = value;
                          }),
                          decoration: const InputDecoration(labelText: 'Kota Tujuan'),
                          validator: (value) =>
                              value == null ? 'Pilih kota tujuan' : null,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          child: _isSubmitting
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Simpan Perubahan'),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
