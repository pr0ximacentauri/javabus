import 'package:flutter/material.dart';
import 'package:javabus/models/bus.dart';
import 'package:provider/provider.dart';
import 'package:javabus/viewmodels/bus_view_model.dart';

class BusUpdateScreen extends StatefulWidget {
  final Bus bus;

  const BusUpdateScreen({super.key, required this.bus});

  @override
  State<BusUpdateScreen> createState() => _BusUpdateScreenState();
}

class _BusUpdateScreenState extends State<BusUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _classController;
  late TextEditingController _totalSeatController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.bus.name);
    _classController = TextEditingController(text: widget.bus.busClass);
    _totalSeatController = TextEditingController(text: widget.bus.totalSeat.toString());
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
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
      final success = await busVM.updateBus(
        widget.bus.id,
        _nameController.text.trim(),
        _classController.text.trim(),
        totalSeat,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(busVM.msg ?? 'Gagal memperbarui bus')),
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
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Bus'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _classController,
                decoration: const InputDecoration(labelText: 'Kelas Bus'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
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
                    : const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
