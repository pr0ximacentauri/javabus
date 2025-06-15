import 'package:flutter/material.dart';
import 'package:javabus/models/city.dart';
import 'package:javabus/models/province.dart';
import 'package:javabus/viewmodels/city_view_model.dart';
import 'package:javabus/viewmodels/province_view_model.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart'; // untuk firstWhereOrNull

class CityUpdateScreen extends StatefulWidget {
  final City city;

  const CityUpdateScreen({super.key, required this.city});

  @override
  State<CityUpdateScreen> createState() => _CityUpdateScreenState();
}

class _CityUpdateScreenState extends State<CityUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isSubmitting = false;
  Province? _selectedProvince;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.city.name);

    final provinceVM = Provider.of<ProvinceViewModel>(context, listen: false);
    provinceVM.fetchProvinces().then((_) {
      setState(() {
        _selectedProvince = provinceVM.provinces.firstWhereOrNull(
          (prov) => prov.id == widget.city.provinceId,
        );
      });
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedProvince == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih provinsi terlebih dahulu')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final cityVM = Provider.of<CityViewModel>(context, listen: false);
      final success = await cityVM.updateCity(
        widget.city.id,
        _nameController.text.trim(),
        _selectedProvince!.id,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(cityVM.msg ?? 'Gagal memperbarui data kota')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProvinceViewModel>(
      builder: (context, provinceVM, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Edit Kota')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nama Kota'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Province>(
                    value: _selectedProvince,
                    items: provinceVM.provinces
                        .map((prov) => DropdownMenuItem(
                              value: prov,
                              child: Text(prov.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProvince = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Provinsi'),
                    validator: (value) =>
                        value == null ? 'Provinsi wajib dipilih' : null,
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
      },
    );
  }
}
