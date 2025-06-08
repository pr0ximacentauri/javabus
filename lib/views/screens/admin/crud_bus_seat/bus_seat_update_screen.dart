import 'package:flutter/material.dart';
import 'package:javabus/models/bus_seat.dart';
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
  late TextEditingController _busIdController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _seatNumberController = TextEditingController(text: widget.seat.seatNumber);
    _busIdController = TextEditingController(text: widget.seat.busId.toString());
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final int? busId = int.tryParse(_busIdController.text.trim());

      if (busId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID bus harus berupa angka')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final seatVM = Provider.of<SeatSelectionViewModel>(context, listen: false);
      final success = await seatVM.updateBusSeat(
        widget.seat.id,
        _seatNumberController.text.trim(),
        busId,
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
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Bus')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _seatNumberController,
                decoration: const InputDecoration(labelText: 'Nomor Kursi'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _busIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ID Bus'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah kursi wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Jumlah kursi harus berupa angka';
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
