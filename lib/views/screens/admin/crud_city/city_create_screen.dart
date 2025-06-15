import 'package:flutter/material.dart';
import 'package:javabus/models/province.dart';
import 'package:javabus/viewmodels/city_view_model.dart';
import 'package:javabus/viewmodels/province_view_model.dart';
import 'package:provider/provider.dart';

class CityCreateScreen extends StatefulWidget {
  const CityCreateScreen({super.key});

  @override
  State<CityCreateScreen> createState() => _CityCreateScreenState();
}

class _CityCreateScreenState extends State<CityCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int? _selectedProvinceId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Ambil data provinsi saat pertama kali layar muncul
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProvinceViewModel>(context, listen: false).fetchProvinces();
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedProvinceId != null) {
      setState(() {
        _isSubmitting = true;
      });

      final cityVM = Provider.of<CityViewModel>(context, listen: false);
      await cityVM.createCity(_nameController.text.trim(), _selectedProvinceId!);

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
    final provinceVM = Provider.of<ProvinceViewModel>(context);
    final List<Province> provinces = provinceVM.provinces;

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
              provinceVM.isLoading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<int>(
                      value: _selectedProvinceId,
                      items: provinces
                          .map((prov) => DropdownMenuItem(
                                value: prov.id,
                                child: Text(prov.name),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedProvinceId = value),
                      decoration: const InputDecoration(labelText: 'Provinsi'),
                      validator: (value) => value == null ? 'Provinsi harus dipilih' : null,
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
