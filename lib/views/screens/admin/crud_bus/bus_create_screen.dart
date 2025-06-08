import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:javabus/viewmodels/bus_view_model.dart';

class BusCreateScreen extends StatefulWidget {
  const BusCreateScreen({super.key});

  @override
  State<BusCreateScreen> createState() => _BusCreateScreenState();
}

class _BusCreateScreenState extends State<BusCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _totalSeatController = TextEditingController();

  bool _isSubmitting = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text.trim();
      final String busClass = _classController.text.trim();
      final int? totalSeat = int.tryParse(_totalSeatController.text.trim());

      if (totalSeat == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jumlah kursi harus berupa angka')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final busVM = Provider.of<BusViewModel>(context, listen: false);
      await busVM.createBus(name, busClass, totalSeat);

      setState(() {
        _isSubmitting = false;
      });

      if (busVM.newBus != null) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(busVM.msg ?? 'Terjadi kesalahan')),
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
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Bus'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama bus wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _classController,
                decoration: const InputDecoration(labelText: 'Kelas Bus'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Kelas bus wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _totalSeatController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah Kursi'),
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
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
