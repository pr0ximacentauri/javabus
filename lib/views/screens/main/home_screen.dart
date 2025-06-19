// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/viewmodels/route_view_model.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';
import 'package:javabus/viewmodels/ticket_view_model.dart';
import 'package:javabus/views/screens/bus_catalog_screen.dart';
import 'package:javabus/views/screens/bus_schedule_screen.dart';
import 'package:javabus/views/screens/cancel_ticket_screen.dart';
import 'package:javabus/views/screens/route_selection_screen.dart';
import 'package:javabus/views/screens/schedule_catalog_screen.dart';
import 'package:javabus/views/screens/terminal_bus_screen.dart';
import 'package:javabus/views/screens/terminal_nearest_screen.dart';
import 'package:javabus/views/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BottomBar();
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
    final ticketVM = Provider.of<TicketViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade600,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/5987/5987424.png'),
            backgroundColor: Colors.amber.shade100,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang, ${authVM.user?.username}!', 
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold, 
                color: Colors.white
              )
            ),
          ],
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.amber.shade100.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.amber.shade600,
              Colors.amber.shade50,
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  shadowColor: Colors.amber.shade200,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.amber.shade50,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            locationButton(
                              icon: Icons.directions_bus,
                              label: "Asal",
                              value: _capitalize(routeVM.selectedOrigin?.name ?? 'Pilih Kota Asal'),
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
                              value: _capitalize(routeVM.selectedDestination?.name ?? 'Pilih Kota Tujuan'),
                              onTap: () async{
                                if(routeVM.selectedOrigin == null){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Pilih kota asal terlebih dahulu!'),
                                      backgroundColor: Colors.orange.shade600,
                                    )
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
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: Colors.amber.shade600,
                                          onPrimary: Colors.white,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
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
                          top: 56,  
                          child: GestureDetector(
                            onTap: () async{
                              bool success = await routeVM.swapRoute();
                              if(!success && routeVM.msg != null){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(routeVM.msg!),
                                    backgroundColor: Colors.orange.shade600,
                                  )
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.amber.shade300, Colors.orange.shade400],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.shade200,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(10),
                              child: const Icon(Icons.swap_vert, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade600, Colors.orange.shade500],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.shade300,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  ),
                  onPressed: () async{
                    if(routeVM.selectedOrigin == null || routeVM.selectedDestination == null || routeVM.selectedDate == null){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Mohon lengkapi data!'),
                          backgroundColor: Colors.orange.shade600,
                        )
                      );
                      return;
                    }
                    final routeId = await routeVM.getRouteId();
                    final formattedDate = DateFormat('yyyy-MM-dd').format(routeVM.selectedDate!);
                    
                    if (routeId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Rute tidak ditemukan!'),
                          backgroundColor: Colors.orange.shade600,
                        ),
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
                  icon: const Icon(Icons.search, color: Colors.white, size: 24),
                  label: const Text(
                    "Cari Bus", 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Layanan Kami',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
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
                      colors: [Colors.amber.shade600, Colors.orange.shade400],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ScheduleCatalogScreen(),
                          ),
                        );
                      },
                    ),
                    _buildCircleButton(
                      icon: Icons.map_outlined,
                      label: 'Terminal Terdekat',
                      colors: [Colors.amber.shade500, Colors.amber.shade700],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TerminalNearestScreen(),
                          ),
                        );
                      },
                    ),
                    _buildCircleButton(
                      icon: Icons.directions_bus_outlined,
                      label: 'Daftar Bus',
                      colors: [Colors.orange.shade600, Colors.orange.shade800],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BusCatalogScreen(),
                          ),
                        );
                      },
                    ),
                    _buildCircleButton(
                      icon: Icons.help,
                      label: 'Pembatalan Tiket',
                      colors: [Colors.amber.shade700, Colors.orange.shade600],
                      onTap: () {
                        final user = authVM.user!;
                        final tickets = ticketVM.tickets;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CancelTicketScreen(user: user, tickets: tickets),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget locationButton({required IconData icon, required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.amber.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade400, Colors.orange.shade400],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label, 
                    style: TextStyle(
                      fontSize: 12, 
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value, 
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.amber.shade600,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required String label,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colors[0].withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(height: 8),
          Text(
            label, 
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}