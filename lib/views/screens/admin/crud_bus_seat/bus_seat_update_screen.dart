import 'package:flutter/material.dart';
import 'package:javabus/models/bus_seat.dart';
import 'package:javabus/viewmodels/bus_view_model.dart';
import 'package:javabus/viewmodels/seat_selection_view_model.dart';
import 'package:provider/provider.dart';

class BusSeatUpdateScreen extends StatefulWidget {
  final BusSeat seat;

  const BusSeatUpdateScreen({super.key, required this.seat});

  @override
  State<BusSeatUpdateScreen> createState() => _BusSeatUpdateScreenState();
}

class _BusSeatUpdateScreenState extends State<BusSeatUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _seatNumberController;
  int? _selectedBusId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _seatNumberController = TextEditingController(text: widget.seat.seatNumber);
    _selectedBusId = widget.seat.busId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BusViewModel>(context, listen: false).fetchBuses();
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedBusId != null) {
      setState(() {
        _isSubmitting = true;
      });

      final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);
      final success = await seatVM.updateBusSeat(
        widget.seat.id,
        _seatNumberController.text.trim(),
        _selectedBusId!,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(seatVM.msg ?? 'Gagal memperbarui kursi bus')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final busVM = Provider.of<BusViewModel>(context);
    final allBuses = busVM.buses;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Kursi Bus')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                items: allBuses.map((bus) {
                  return DropdownMenuItem(
                    value: bus.id,
                    child: Text('${bus.name} (${bus.busClass})'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedBusId = value),
                decoration: const InputDecoration(labelText: 'Pilih Bus'),
                validator: (value) => value == null ? 'Bus harus dipilih' : null,
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
