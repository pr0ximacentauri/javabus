import 'package:flutter/material.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/views/widgets/navbar.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navbar();
  }
}

class AccountContent extends StatelessWidget {
  const AccountContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://cdn-icons-png.flaticon.com/512/5987/5987424.png",
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_capitalize(authVM.user?.fullName)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1, color: Colors.grey),
           
            ListTile(
              leading: const Icon(Icons.mode_edit),
              title: const Text('Edit Profil'),
              onTap: () {
                
              },
            ),
            const Divider(thickness: 1, color: Colors.grey),
            
            ListTile(
              leading: const Icon(Icons.account_circle_sharp),
              title: const Text('Ubah Password'),
              onTap: () {
                // Navigator.pushNamed(context, '/reset-password');
              },
            ),
            const Divider(thickness: 1, color: Colors.grey),
            

            ListTile(
              leading: const Icon(Icons.contact_support),
              title: const Text('Bantuan'),
              onTap: () {
                
              },
            ),
            const Divider(thickness: 1, color: Colors.grey),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tentang Aplikasi'),
              onTap: () {
                
              },
            ),
            const Divider(thickness: 1, color: Colors.grey),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                final confirmLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text("Konfirmasi"),
                    content: const Text("Apakah kamu yakin ingin logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Batal", style: TextStyle(color: Colors.black),),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Logout", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirmLogout == true){
                  await authVM.logout();  
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String? _capitalize(String? text) {
    return text?.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}