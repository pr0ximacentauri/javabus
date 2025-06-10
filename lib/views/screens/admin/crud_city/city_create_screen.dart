import 'package:flutter/material.dart';
import 'package:javabus/viewmodels/city_view_model.dart';
import 'package:provider/provider.dart';

class CityCreateScreen extends StatefulWidget {
  const CityCreateScreen({super.key});

  @override
  State<CityCreateScreen> createState() => _CityCreateScreenState();
}

class _CityCreateScreenState extends State<CityCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _provinceIdController = TextEditingController();
  bool _isSubmitting = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text.trim();
      final int? provinceId = int.tryParse(_provinceIdController.text.trim());
      if (provinceId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID provinsi harus berupa angka')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final cityVM = Provider.of<CityViewModel>(context, listen: false);
      await cityVM.createCity(name, provinceId);

      setState(() {
        _isSubmitting = false;
      });

      if (cityVM.cities.isNotEmpty) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(cityVM.msg ?? 'Terjadi kesalahan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kota')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Kota'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama kota wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _provinceIdController,
                decoration: const InputDecoration(labelText: 'ID Provinsi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID provinsi wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'ID provinsi harus berupa angka';
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
