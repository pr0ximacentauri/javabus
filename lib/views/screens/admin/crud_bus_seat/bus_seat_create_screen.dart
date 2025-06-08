import 'package:flutter/material.dart';
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
  final _busIdController = TextEditingController();

  bool _isSubmitting = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final String seatNumber = _seatNumberController.text.trim();
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
      await seatVM.createBusSeat(seatNumber, busId);

      setState(() {
        _isSubmitting = false;
      });

      if (seatVM.newBusSeat != null) {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Bus')),
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
                    value == null || value.isEmpty ? 'Nommor kursi bus wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _busIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ID Bus'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID bus wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'ID bus harus berupa angka';
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
