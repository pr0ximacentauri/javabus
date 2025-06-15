import 'package:flutter/material.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/views/screens/admin/crud_booking/booking_list_screen.dart';
import 'package:javabus/views/screens/admin/crud_bus/bus_list_screen.dart';
import 'package:javabus/views/screens/admin/crud_bus_route/bus_route_list_screen.dart';
import 'package:javabus/views/screens/admin/crud_bus_seat/bus_seat_list_screen.dart';
import 'package:javabus/views/screens/admin/crud_city/city_list_screen.dart';
import 'package:javabus/views/screens/admin/crud_schedule/schedule_list_screen.dart';
import 'package:javabus/views/screens/admin/crud_seat_booking/seat_booking_list_screen.dart';
import 'package:javabus/views/screens/admin/crud_ticket/ticket_list_screen.dart';
import 'package:javabus/views/widgets/admin_bottom_bar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminBottomBar();
  }
}

class AdminHomeContent extends StatelessWidget {
  const AdminHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    final List<_CrudItem> crudItems = [
      _CrudItem(
        title: 'Data Booking Tiket',
        icon: LucideIcons.bookOpenCheck,
        screenClass: () => BookingListScreen(), 
        color: Colors.amber.shade700,
      ),
      _CrudItem(
        title: 'Data Rute Bus',
        icon: LucideIcons.map,
        screenClass: () => BusRouteListScreen(), 
        color: Colors.amber.shade600,
      ),
      _CrudItem(
        title: 'Data Kursi Bus',
        icon: LucideIcons.sofa,
        screenClass: () => BusSeatListScreen(), 
        color: Colors.amber.shade800,
      ),
      _CrudItem(
        title: 'Data Bus',
        icon: LucideIcons.bus,
        screenClass: () => BusListScreen(), 
        color: Colors.orange.shade700,
      ),
      _CrudItem(
        title: 'Data Kota',
        icon: LucideIcons.mapPin,
        screenClass: () => CityListScreen(), 
        color: Colors.amber.shade700,
      ),
      _CrudItem(
        title: 'Data Jadwal Bus',
        icon: LucideIcons.calendarDays,
        screenClass: () => ScheduleListScreen(), 
        color: Colors.orange.shade600,
      ),
      _CrudItem(
        title: 'Data Booking Kursi ',
        icon: LucideIcons.bookMarked,
        screenClass: () => SeatBookingListScreen(), 
        color: Colors.orange.shade700,
      ),
      _CrudItem(
        title: 'Data Tiket Penumpang',
        icon: LucideIcons.ticket,
        screenClass: () => TicketListScreen(), 
        color: Colors.amber.shade800,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
       appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.dashboard,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang, ${authVM.user?.username}!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Kelola data sistem bus',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // Agar tidak menutupi gradient
        elevation: 0, // Hilangkan bayangan AppBar
      ),
      body: Column(
        children: [
          
          // Grid Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: crudItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final item = crudItems[index];
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          item.color.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: item.color.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => item.screenClass(),
                            ),
                          );
                        },
                        child: 
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      item.color.withOpacity(0.1),
                                      item.color.withOpacity(0.2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  item.icon,
                                  size: 32,
                                  color: item.color,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [item.color, item.color.withOpacity(0.8)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Kelola',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CrudItem {
  final String title;
  final IconData icon;
  final Widget Function() screenClass;
  final Color color;

  const _CrudItem({
    required this.title,
    required this.icon,
    required this.screenClass,
    required this.color,
  });
}
