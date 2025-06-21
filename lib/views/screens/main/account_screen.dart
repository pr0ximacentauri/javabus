// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/viewmodels/ticket_view_model.dart';
import 'package:javabus/views/screens/cancel_ticket_screen.dart';
import 'package:javabus/views/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomBar();
  }
}

class AccountContent extends StatelessWidget {
  const AccountContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final ticketVM = Provider.of<TicketViewModel>(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.amber, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/5987/5987424.png",
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_capitalize(authVM.user?.fullName)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.edit,
                    title: 'Edit Profil',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Ubah Password',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Pembatalan Tiket',
                    onTap: () {
                      final user = authVM.user!;
                      final tickets = ticketVM.tickets.where((t) => t.ticketStatus == 'belum terpakai').toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CancelTicketScreen(user: user, tickets: tickets))
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'Tentang Aplikasi',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            // Logout Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                iconColor: Colors.red,
                titleColor: Colors.red,
                onTap: () async {
                  final confirmLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 28),
                          const SizedBox(width: 8),
                          const Text("Konfirmasi"),
                        ],
                      ),
                      content: const Text("Apakah kamu yakin ingin logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                          ),
                          child: const Text("Batal"),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.red, Colors.redAccent],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Logout"),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirmLogout == true) {
                    await authVM.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? Colors.amber).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? Colors.amber.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: titleColor ?? Colors.grey[800],
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Colors.grey[200],
      indent: 60,
    );
  }

  String? _capitalize(String? text) {
    return text?.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}