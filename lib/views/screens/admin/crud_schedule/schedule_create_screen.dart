import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';
import 'package:provider/provider.dart';

class ScheduleCreateScreen extends StatefulWidget {
  const ScheduleCreateScreen({super.key});

  @override
  State<ScheduleCreateScreen> createState() => _ScheduleCreateScreenState();
}

class _ScheduleCreateScreenState extends State<ScheduleCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDateTime;
  int? _ticketPrice;
  int? _busId;
  int? _routeId;

  bool _isSubmitting = false;

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final initialDate = _selectedDateTime?.isAfter(firstDate) == true
        ? _selectedDateTime!
        : now.add(const Duration(hours: 1));

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? now),
      );
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
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

      setState(() => _isSubmitting = true);

      final scheduleVM = Provider.of<ScheduleViewModel>(context, listen: false);
      final success = await scheduleVM.createSchedule(
        _selectedDateTime!,
        _ticketPrice!,
        _busId!,
        _routeId!,
      );

      setState(() => _isSubmitting = false);

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Jadwal Bus')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickDateTime,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Waktu Keberangkatan',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_selectedDateTime == null
                          ? 'Pilih waktu'
                          : DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: '',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga Tiket',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Harga tiket wajib diisi';
                  final parsed = int.tryParse(value);
                  if (parsed == null) return 'Harga tiket harus berupa angka';
                  _ticketPrice = parsed;
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: '',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID Bus',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'ID Bus wajib diisi';
                  final parsed = int.tryParse(value);
                  if (parsed == null) return 'ID Bus harus berupa angka';
                  _busId = parsed;
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: '',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID Rute',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'ID Rute wajib diisi';
                  final parsed = int.tryParse(value);
                  if (parsed == null) return 'ID Rute harus berupa angka';
                  _routeId = parsed;
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
