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
  late TextEditingController _departureTimeController;
  late TextEditingController _ticketPriceController;
  late TextEditingController _busIdController;
  late TextEditingController _routeIdController;

  DateTime? _selectedDateTime;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.schedule.departureTime;
    _departureTimeController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm').format(widget.schedule.departureTime),
    );
    _ticketPriceController = TextEditingController(text: widget.schedule.ticketPrice.toString());
    _busIdController = TextEditingController(text: widget.schedule.busId.toString());
    _routeIdController = TextEditingController(text: widget.schedule.routeId.toString());
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );
      if (time != null) {
        final picked = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        setState(() {
          _selectedDateTime = picked;
          _departureTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(picked);
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

      final ticketPrice = int.tryParse(_ticketPriceController.text.trim());
      final busId = int.tryParse(_busIdController.text.trim());
      final routeId = int.tryParse(_routeIdController.text.trim());

      if (ticketPrice == null || busId == null || routeId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua field harus berupa angka')),
        );
        return;
      }

      setState(() => _isSubmitting = true);

      final scheduleVM = Provider.of<ScheduleViewModel>(context, listen: false);
      final success = await scheduleVM.updateSchedule(
        widget.schedule.id,
        _selectedDateTime!,
        ticketPrice,
        busId,
        routeId
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
      appBar: AppBar(title: const Text('Edit Jadwal Bus')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ticketPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga Tiket'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  if (int.tryParse(value) == null) return 'Harus angka';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _busIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ID Bus'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  if (int.tryParse(value) == null) return 'Harus angka';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _routeIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ID Rute'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  if (int.tryParse(value) == null) return 'Harus angka';
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
