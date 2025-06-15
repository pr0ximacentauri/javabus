import 'package:flutter/material.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
import 'package:provider/provider.dart';

class BookingCreateScreen extends StatefulWidget {
  const BookingCreateScreen({super.key});

  @override
  State<BookingCreateScreen> createState() => _BusCreateScreenState();
}

class _BusCreateScreenState extends State<BookingCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _statusController = TextEditingController();
  final _userIdController = TextEditingController();
  final _scheduleIdController = TextEditingController();

  bool _isSubmitting = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final String status = _statusController.text.trim();
      final int? userId = int.tryParse(_userIdController.text.trim());
      final int? scheduleId = int.tryParse(_scheduleIdController.text.trim());

      if (userId == null || scheduleId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID user dan schedule harus berupa angka')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
      final success = await bookingVM.createBooking(status, userId, scheduleId);

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(bookingVM.msg ?? 'Terjadi kesalahan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status Booking'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Status booking wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'ID User'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID user wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'ID user harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _scheduleIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ID Schedule'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID schedule wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'ID schedule harus berupa angka';
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
