import 'package:flutter/material.dart';
import 'package:javabus/views/widgets/admin_navbar.dart';

class AdminCrudScreen extends StatelessWidget {
  const AdminCrudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminNavbar();
  }
}

class AdminCrudContent extends StatelessWidget {
  const AdminCrudContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List CRUD')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Data Booking Tiket'),
            onTap: () {
              Navigator.pushNamed(context, '/admin/booking');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Data Rute Bus'),
            onTap: () {
              Navigator.pushNamed(context, '/admin/bus-route');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Data Kursi Bus'),
            onTap: () {
              Navigator.pushNamed(context, '/admin/bus-seat');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Data Bus'),
            onTap: () {
              Navigator.pushNamed(context, '/admin/bus');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Data Kota'),
            onTap: () {
              Navigator.pushNamed(context, '/admin/city');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Data Jadwal Bus'),
            onTap: () {
              Navigator.pushNamed(context, '/admin/schedule');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Data Tiket Bus Penumpang'),
            onTap: () {
              Navigator.pushNamed(context, '/admin/ticket');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Data Pengguna'),
            onTap: () {
              Navigator.pushNamed(context, '/admin/user');
            },
          ),

        ],
      )
    );
  }
}