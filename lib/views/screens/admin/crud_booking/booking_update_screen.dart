import 'package:flutter/material.dart';
import 'package:javabus/models/booking.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
import 'package:provider/provider.dart';

class BookingUpdateScreen extends StatefulWidget {
  final Booking booking;

  const BookingUpdateScreen({super.key, required this.booking});

  @override
  State<BookingUpdateScreen> createState() => _BusUpdateScreenState();
}

class _BusUpdateScreenState extends State<BookingUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _statusController;
  late TextEditingController _userIdController;
  late TextEditingController _scheduleIdController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _statusController = TextEditingController(text: widget.booking.status);
    _userIdController = TextEditingController(text: widget.booking.userId.toString());
    _scheduleIdController = TextEditingController(text: widget.booking.scheduleId.toString());
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
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

      final busVM = Provider.of<BookingViewModel>(context, listen: false);
      final success = await busVM.updateBooking(
        widget.booking.id,
        _statusController.text.trim(),
        userId,
        scheduleId
      );

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(busVM.msg ?? 'Gagal memperbarui booking')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status Booking'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
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
                    : const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
