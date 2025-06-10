import 'package:flutter/material.dart';
import 'package:javabus/views/widgets/admin_navbar.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminNavbar();
  }
}

class AdminHomeContent extends StatelessWidget {
  const AdminHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_CrudItem> crudItems = [
      _CrudItem(
        title: 'Data Booking Tiket',
        icon: LucideIcons.bookOpenCheck,
        route: '/admin/booking',
        color: Colors.indigo,
      ),
      _CrudItem(
        title: 'Data Rute Bus',
        icon: LucideIcons.map,
        route: '/admin/bus-route',
        color: Colors.orange,
      ),
      _CrudItem(
        title: 'Data Kursi Bus',
        icon: LucideIcons.sofa,
        route: '/admin/bus-seat',
        color: Colors.green,
      ),
      _CrudItem(
        title: 'Data Bus',
        icon: LucideIcons.bus,
        route: '/admin/bus',
        color: Colors.blue,
      ),
      _CrudItem(
        title: 'Data Kota',
        icon: LucideIcons.mapPin,
        route: '/admin/city',
        color: Colors.purple,
      ),
      _CrudItem(
        title: 'Data Jadwal Bus',
        icon: LucideIcons.calendarDays,
        route: '/admin/schedule',
        color: Colors.teal,
      ),
      _CrudItem(
        title: 'Data Tiket Penumpang',
        icon: LucideIcons.ticket,
        route: '/admin/ticket',
        color: Colors.redAccent,
      ),
      _CrudItem(
        title: 'Data Pengguna',
        icon: LucideIcons.users,
        route: '/admin/user',
        color: Colors.brown,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin - Navigasi CRUD'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: crudItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 4 / 3,
          ),
          itemBuilder: (context, index) {
            final item = crudItems[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, item.route);
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                // ignore: deprecated_member_use
                color: item.color.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, size: 36, color: item.color),
                      const SizedBox(height: 12),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: item.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CrudItem {
  final String title;
  final IconData icon;
  final String route;
  final Color color;

  const _CrudItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.color,
  });
}
