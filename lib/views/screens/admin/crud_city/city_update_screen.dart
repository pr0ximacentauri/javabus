// import 'package:flutter/material.dart';
// import 'package:javabus/models/city.dart';
// import 'package:javabus/viewmodels/route_view_model.dart';
// import 'package:provider/provider.dart';

// class CityUpdateScreen extends StatefulWidget {
//   final City city;

//   const CityUpdateScreen({super.key, required this.city});

//   @override
//   State<CityUpdateScreen> createState() => _CityUpdateScreenState();
// }

// class _CityUpdateScreenState extends State<CityUpdateScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _provinceIdController;
//   bool _isSubmitting = false;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.city.name);
//     _provinceIdController = TextEditingController(text: widget.city.provinceId.toString());
//   }

//   void _submit() async {
//     if (_formKey.currentState!.validate()) {
//       final int? provinceId= int.tryParse(_provinceIdController.text.trim());
//       if (provinceId == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('ID bus harus berupa angka')),
//         );
//         return;
//       }

//       setState(() {
//         _isSubmitting = true;
//       });

//       final cityVM = Provider.of<RouteViewModel>(context, listen: false);
//       final success = await cityVM.updateCity(
//         widget.city.id,
//         _nameController.text.trim(),
//         provinceId,
//       );

//       setState(() {
//         _isSubmitting = false;
//       });

//       if (success) {
//         Navigator.pop(context, true);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(cityVM.msg ?? 'Gagal memperbarui kursi bus')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Edit Kota')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Nama Kota'),
//                 validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _provinceIdController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: 'ID Provinsi'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'ID provinsi wajib diisi';
//                   }
//                   if (int.tryParse(value) == null) {
//                     return 'ID provinsi harus berupa angka';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _isSubmitting ? null : _submit,
//                 child: _isSubmitting
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text('Simpan Perubahan'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
