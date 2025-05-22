import 'package:flutter/material.dart';
import 'package:javabus/views/widgets/admin_navbar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminNavbar();
  }
}

class AdminHomeContent extends StatelessWidget {
  const AdminHomeContent({super.key});

  void _openSwagger() async {
    const url = 'https://localhost:32769/swagger';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Hari Ini',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _DashboardCard(
                  icon: LucideIcons.ticket,
                  title: 'Tiket Terjual',
                  value: '120',
                  color: Colors.blue,
                ),
                _DashboardCard(
                  icon: LucideIcons.creditCard,
                  title: 'Pendapatan',
                  value: 'Rp 4.200.000',
                  color: Colors.green,
                ),
                _DashboardCard(
                  icon: LucideIcons.users,
                  title: 'User Aktif',
                  value: '87',
                  color: Colors.orange,
                ),
                _DashboardCard(
                  icon: LucideIcons.bus,
                  title: 'Keberangkatan',
                  value: '6',
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _openSwagger,
                icon: const Icon(Icons.link),
                label: const Text('Ubah Data API'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
