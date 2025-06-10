import 'package:flutter/material.dart';
import 'package:javabus/views/widgets/bottom_bar.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override

  Widget build(BuildContext context) {
    return BottomBar();
  }
}

class HelpCenterContent extends StatelessWidget {
  const HelpCenterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                children: const [
                  Card(
                    child: ListTile(
                      title: Text('Bagaimana cara memesan tiket?'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Bagaimana cara membatalkan tiket?'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Apakah bisa memesan lebih dari satu tiket?'),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 32),
            const Text(
              'Butuh bantuan lebih lanjut?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.email, color: Colors.black,),
                  label: const Text('Email', style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.chat, color: Colors.black,),
                  label: const Text('WhatsApp', style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}