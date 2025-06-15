import 'package:flutter/material.dart';
import 'package:javabus/models/bus.dart';
import 'package:javabus/viewmodels/bus_view_model.dart';
import 'package:javabus/viewmodels/seat_selection_view_model.dart';
import 'package:provider/provider.dart';

class BusSeatCreateScreen extends StatefulWidget {
  const BusSeatCreateScreen({super.key});

  @override
  State<BusSeatCreateScreen> createState() => _BusSeatCreateScreenState();
}

class _BusSeatCreateScreenState extends State<BusSeatCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _seatNumberController = TextEditingController();
  int? _selectedBusId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<BusViewModel>(context, listen: false).fetchBuses();
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final String seatNumber = _seatNumberController.text.trim();

      if (_selectedBusId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan pilih bus')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);
      final success = await seatVM.createBusSeat(seatNumber, _selectedBusId!);

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(seatVM.msg ?? 'Terjadi kesalahan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final busVM = Provider.of<BusViewModel>(context);
    final List<Bus> busList = busVM.buses;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kursi Bus')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _seatNumberController,
                decoration: const InputDecoration(labelText: 'Nomor Kursi'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nomor kursi wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _selectedBusId,
                decoration: const InputDecoration(labelText: 'Pilih Bus'),
                items: busList
                    .map((bus) => DropdownMenuItem<int>(
                          value: bus.id,
                          child: Text('${bus.name} (${bus.busClass})'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBusId = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Bus wajib dipilih' : null,
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
