// import 'package:flutter/material.dart';
// import 'package:javabus/models/city.dart';
// import 'package:javabus/viewmodels/route_view_model.dart';
// import 'package:javabus/views/screens/admin/crud_city/city_create_screen.dart';
// import 'package:javabus/views/screens/admin/crud_city/city_update_screen.dart';
// import 'package:provider/provider.dart';

// class CityListScreen extends StatefulWidget {
//   const CityListScreen({super.key});

//   @override
//   State<CityListScreen> createState() => _CityListScreenState();
// }

// class _CityListScreenState extends State<CityListScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<RouteViewModel>(context, listen: false).fetchCities();
//     });
//   }

//   void _navigateToCreate() {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => const CityCreateScreen()));
//   }

//   void _navigateToUpdate(City city) {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => CityUpdateScreen(city: city)));
//   }

//   void _delete(int id) async {
//     final routeVM = Provider.of<RouteViewModel>(context, listen: false);
//     final success = await routeVM.deleteCity(id);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(success ? 'kota dihapus' : 'Gagal hapus kota')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<RouteViewModel>(
//       builder: (context, routeVM, _) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Data Kota'),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: _navigateToCreate,
//               ),
//             ],
//           ),
//           body: routeVM.isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : routeVM.msg != null
//                   ? Center(child: Text(routeVM.msg!))
//                   : ListView.builder(
//                       itemCount: routeVM.cities.length,
//                       itemBuilder: (context, index) {
//                         final city = routeVM.cities[index];
//                         return ListTile(
//                           title: Text('${city.name}, ID Provinsi: ${city.provinceId}'),
//                           subtitle: Text('ID: ${city.id}'),
//                           trailing: PopupMenuButton<String>(
//                             onSelected: (value) {
//                               if (value == 'edit') {
//                                 _navigateToUpdate(city);
//                               } else if (value == 'delete') {
//                                 _delete(city.id);
//                               }
//                             },
//                             itemBuilder: (context) => [
//                               const PopupMenuItem(value: 'edit', child: Text('Update')),
//                               const PopupMenuItem(value: 'delete', child: Text('Delete')),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//         );
//       },
//     );
//   }
// }
