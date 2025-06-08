import 'package:flutter/material.dart';
import 'package:javabus/models/bus_route.dart';
import 'package:javabus/viewmodels/route_view_model.dart';
import 'package:provider/provider.dart';

class BusRouteUpdateScreen extends StatefulWidget {
  final BusRoute busRoute;

  const BusRouteUpdateScreen({super.key, required this.busRoute});

  @override
  State<BusRouteUpdateScreen> createState() => _BusRouteUpdateScreenState();
}

class _BusRouteUpdateScreenState extends State<BusRouteUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _originCityController;
  late TextEditingController _destinationCityController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _originCityController = TextEditingController(text: widget.busRoute.originCityId.toString());
    _destinationCityController = TextEditingController(text: widget.busRoute.destinationCityId.toString());
  }

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
      final success = await routeVM.updateBusRoute(
        widget.busRoute.id,
        originCityId,
        destinationCityId
      );

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(routeVM.msg ?? 'Gagal memperbarui bus')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Bus')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    : const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
