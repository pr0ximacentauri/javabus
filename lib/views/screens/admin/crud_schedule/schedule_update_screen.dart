import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javabus/models/schedule.dart';
import 'package:provider/provider.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';

class ScheduleUpdateScreen extends StatefulWidget {
  final Schedule schedule;

  const ScheduleUpdateScreen({super.key, required this.schedule});

  @override
  State<ScheduleUpdateScreen> createState() => _ScheduleUpdateScreenState();
}

class _ScheduleUpdateScreenState extends State<ScheduleUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _selectedDateTime;
  late int _ticketPrice;
  late int _busId;
  late int _routeId;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.schedule.departureTime;
    _ticketPrice = widget.schedule.ticketPrice;
    _busId = widget.schedule.busId;
    _routeId = widget.schedule.routeId;
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);

    // Normalisasi _selectedDateTime ke jam 00:00 untuk perbandingan
    final selectedDateOnly = _selectedDateTime != null
        ? DateTime(_selectedDateTime!.year, _selectedDateTime!.month, _selectedDateTime!.day)
        : null;

    final initialDate = (selectedDateOnly == null || selectedDateOnly.isBefore(firstDate))
        ? firstDate
        : selectedDateOnly;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final initialTime = TimeOfDay.fromDateTime(_selectedDateTime ?? now);

      final time = await showTimePicker(
        context: context,
        initialTime: initialTime,
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
      if (_selectedDateTime.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Waktu keberangkatan tidak boleh di masa lalu')),
        );
        return;
      }

      setState(() => _isSubmitting = true);

      final scheduleVM = Provider.of<ScheduleViewModel>(context, listen: false);
      final success = await scheduleVM.updateSchedule(
        widget.schedule.id,
        _selectedDateTime,
        _ticketPrice,
        _busId,
        _routeId,
      );

      setState(() => _isSubmitting = false);

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(scheduleVM.msg ?? 'Gagal memperbarui jadwal')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Jadwal Bus')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      Text(DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _ticketPrice.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga Tiket',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  if (int.tryParse(value) == null) return 'Harus angka';
                  return null;
                },
                onChanged: (value) => _ticketPrice = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _busId.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID Bus',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  if (int.tryParse(value) == null) return 'Harus angka';
                  return null;
                },
                onChanged: (value) => _busId = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _routeId.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID Rute',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  if (int.tryParse(value) == null) return 'Harus angka';
                  return null;
                },
                onChanged: (value) => _routeId = int.tryParse(value) ?? 0,
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
