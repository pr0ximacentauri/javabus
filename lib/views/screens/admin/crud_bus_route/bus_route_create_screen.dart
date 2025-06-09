import 'package:flutter/material.dart';
import 'package:javabus/viewmodels/route_view_model.dart';
import 'package:provider/provider.dart';

class BusRouteCreateScreen extends StatefulWidget {
  const BusRouteCreateScreen({super.key});

  @override
  State<BusRouteCreateScreen> createState() => _BusRouteCreateScreenState();
}

class _BusRouteCreateScreenState extends State<BusRouteCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _originCityController = TextEditingController();
  final _destinationCityController = TextEditingController();
  bool _isSubmitting = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final int? originCityId = int.tryParse(_originCityController.text.trim());
      final int? destinationCityId = int.tryParse(_destinationCityController.text.trim());
      if (originCityId == null || destinationCityId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID kota asal & tujuan harus berupa angka')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final routeVM = Provider.of<RouteViewModel>(context, listen: false);
      await routeVM.createBusRoute(originCityId, destinationCityId);

      setState(() {
        _isSubmitting = false;
      });

      if (routeVM.newBusRoute != null) {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Rute Bus')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _originCityController,
                decoration: const InputDecoration(labelText: 'ID Kota Asal'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID kota asal wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'ID kota asal harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _destinationCityController,
                decoration: const InputDecoration(labelText: 'ID Kota Tujuan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID kota tujuan wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'ID kota tujuan harus berupa angka';
                  }
                  return null;
                },
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
