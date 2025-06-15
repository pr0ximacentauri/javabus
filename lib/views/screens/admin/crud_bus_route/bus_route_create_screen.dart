import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:javabus/viewmodels/city_view_model.dart';
import 'package:javabus/viewmodels/route_view_model.dart';

class BusRouteCreateScreen extends StatefulWidget {
  const BusRouteCreateScreen({super.key});

  @override
  State<BusRouteCreateScreen> createState() => _BusRouteCreateScreenState();
}

class _BusRouteCreateScreenState extends State<BusRouteCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedOriginCityId;
  int? _selectedDestinationCityId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CityViewModel>(context, listen: false).fetchCities();
      Provider.of<RouteViewModel>(context, listen: false).fetchBusRoutes();
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedOriginCityId == _selectedDestinationCityId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kota asal dan tujuan tidak boleh sama')),
        );
        return;
      }

      setState(() => _isSubmitting = true);

      final routeVM = Provider.of<RouteViewModel>(context, listen: false);
      final existing = routeVM.busRoutes.any((r) =>
          r.originCityId == _selectedOriginCityId &&
          r.destinationCityId == _selectedDestinationCityId);

      if (existing) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rute ini sudah ada')),
        );
        return;
      }

      final success = await routeVM.createBusRoute(
        _selectedOriginCityId!,
        _selectedDestinationCityId!,
      );

      setState(() => _isSubmitting = false);

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(routeVM.msg ?? 'Terjadi kesalahan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cityVM = Provider.of<CityViewModel>(context);
    final cities = cityVM.cities;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Rute Bus')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: _selectedOriginCityId,
                items: cities
                    .map((city) => DropdownMenuItem(
                          value: city.id,
                          child: Text('${city.name} (${city.province?.name ?? "-"})'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOriginCityId = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Kota Asal'),
                validator: (value) => value == null ? 'Pilih kota asal' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _selectedDestinationCityId,
                items: cities
                    .map((city) => DropdownMenuItem(
                          value: city.id,
                          child: Text('${city.name} (${city.province?.name ?? "-"})'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDestinationCityId = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Kota Tujuan'),
                validator: (value) => value == null ? 'Pilih kota tujuan' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
