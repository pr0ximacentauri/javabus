import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/viewmodels/route_view_model.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';
import 'package:javabus/views/screens/bus_schedule_screen.dart';
import 'package:javabus/views/screens/help_center_screen.dart';
import 'package:javabus/views/screens/route_selection_screen.dart';
import 'package:javabus/views/screens/terminal_bus_screen.dart';
import 'package:javabus/views/widgets/navbar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Navbar();
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}


class _HomeContentState extends State<HomeContent> {

  @override
  Widget build(BuildContext context) {
    final routeVM = Provider.of<RouteViewModel>(context);
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/5987/5987424.png'),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat Datang, ${authVM.user?.username}!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        locationButton(
                          icon: Icons.directions_bus,
                          label: "Asal",
                          value: routeVM.selectedOrigin?.name ?? 'Pilih Kota Asal',
                          onTap: () async{
                            await routeVM.loadOrigins();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RouteSelectionScreen(isOriginSelection: true),
                              ),
                            );
                          },
                        ),
                        locationButton(
                          icon: Icons.location_on,
                          label: "Tujuan",
                          value: routeVM.selectedDestination?.name ?? 'Pilih Kota Tujuan',
                          onTap: () async{
                            if(routeVM.selectedOrigin == null){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Pilih kota asal terlebih dahulu!'))
                              );
                              return;
                            }
                            await routeVM.loadDestinations(routeVM.selectedOrigin!.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RouteSelectionScreen(isOriginSelection: false),
                              ),
                            );
                          },
                        ),
                        locationButton(
                          icon: Icons.date_range,
                          label: "Tanggal Keberangkatan",
                          value: routeVM.selectedDate != null 
                                 ? "${routeVM.selectedDate!.day}-${routeVM.selectedDate!.month}-${routeVM.selectedDate!.year}"
                                 : 'Pilih Tanggal Keberangkatan',
                          onTap: () async{
                             final selected = await showDatePicker(
                              context: context, 
                              firstDate: DateTime.now(), 
                              lastDate: DateTime.now().add(const Duration( days: 30)),
                            );
                            if (selected != null) {
                              routeVM.selectedDate = selected;
                              routeVM.notifyListeners();
                            }
                          },
                        ),
                      ],
                    ),
                    Positioned(
                      right: 16,
                      top: 46,  
                      child: GestureDetector(
                        onTap: () async{
                          bool success = await routeVM.swapRoute();
                          if(!success && routeVM.msg != null){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(routeVM.msg!))
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.swap_vert, color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 152, vertical: 14),
              ),
              onPressed: () async{
                if(routeVM.selectedOrigin == null || routeVM.selectedDestination == null || routeVM.selectedDate == null){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mohon lengkapi data!'))
                  );
                  return;
                }
                final routeId = await routeVM.getRouteId();
                final formattedDate = DateFormat('yyyy-MM-dd').format(routeVM.selectedDate!);
                
                if (routeId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rute tidak ditemukan!')),
                  );
                  return;
                }

                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) => ScheduleViewModel()..getSchedulesByRouteAndDate(routeId, formattedDate),
                      child: const BusScheduleScreen(),
                    ),
                  )
                );
              },
              icon: const Icon(Icons.search, color: Colors.black,),
              label: const Text("Cari bus", style: TextStyle(color: Colors.black),),
            ),

            SizedBox(height: 20),
            SizedBox(
              height: 120, 
              child: GridView.count(
                crossAxisCount: 1,
                scrollDirection: Axis.horizontal,
                childAspectRatio: 1,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCircleButton(
                    icon: Icons.calendar_month,
                    label: 'Jadwal Bus',
                    color: Colors.yellow.shade900,
                    onTap: () => print('Jadwal tapped'),
                  ),
                  _buildCircleButton(
                    icon: Icons.map,
                    label: 'Terminal Bus',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TerminalBusContent(),
                        ),
                      );
                    },
                  ),
                  _buildCircleButton(
                    icon: Icons.map_outlined,
                    label: 'Terminal Terdekat',
                    color: Colors.cyan,
                    onTap: () => print('terminal terdekat tapped'),
                  ),
                  _buildCircleButton(
                    icon: Icons.directions_bus_outlined,
                    label: 'Daftar Bus',
                    color: Colors.green,
                    onTap: () => print('Daftar tapped'),
                  ),
                  _buildCircleButton(
                    icon: Icons.help,
                    label: 'Bantuan',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpCenterContent(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text('Rekomendasi Tempat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/borobudur-temple.webp',
                              width: 300,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Yogyakarta',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/ijen.jpg',
                              width: 300,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Banyuwangi',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget locationButton({required IconData icon, required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            // const Icon(Icons.location_on, color: Colors.black54),
            Icon(icon, color: Colors.amberAccent),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}