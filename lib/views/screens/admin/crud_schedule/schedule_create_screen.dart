import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';
import 'package:provider/provider.dart';

class ScheduleCreateScreen extends StatefulWidget {
  const ScheduleCreateScreen({super.key});

  @override
  State<ScheduleCreateScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _departureTimeController = TextEditingController();
  final _ticketPriceController = TextEditingController();
  final _busIdController = TextEditingController();
  final _routeIdController = TextEditingController();

  DateTime? _selectedDateTime;
  bool _isSubmitting = false;

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        final DateTime dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        setState(() {
          _selectedDateTime = dateTime;
          _departureTimeController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
        });
      }
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDateTime == null || _selectedDateTime!.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Waktu keberangkatan tidak boleh di masa lalu')),
        );
        return;
      }

      final int? ticketPrice = int.tryParse(_ticketPriceController.text.trim());
      final int? busId = int.tryParse(_busIdController.text.trim());
      final int? routeId = int.tryParse(_routeIdController.text.trim());

      if (ticketPrice == null || busId == null || routeId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harga, Bus ID, dan Route ID harus berupa angka')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final scheduleVM = Provider.of<ScheduleViewModel>(context, listen: false);
      final success = await scheduleVM.createSchedule(_selectedDateTime!, ticketPrice, busId, routeId);

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(scheduleVM.msg ?? 'Terjadi kesalahan')),
        );
      }
    }
  }

  @override
  void dispose() {
    _departureTimeController.dispose();
    _ticketPriceController.dispose();
    _busIdController.dispose();
    _routeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Jadwal Bus')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _departureTimeController,
                readOnly: true,
                onTap: _pickDateTime,
                decoration: const InputDecoration(labelText: 'Waktu Keberangkatan'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Waktu keberangkatan wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ticketPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga Tiket'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Harga tiket wajib diisi';
                  if (int.tryParse(value) == null) return 'Harga tiket harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _busIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ID Bus'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'ID Bus wajib diisi';
                  if (int.tryParse(value) == null) return 'ID Bus harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _routeIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ID Rute'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'ID Rute wajib diisi';
                  if (int.tryParse(value) == null) return 'ID Rute harus berupa angka';
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
