import 'package:flutter/material.dart';
import 'package:javabus/views/widgets/navbar.dart';

class TicketView extends StatelessWidget {
  const TicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Navbar();
  }
}

class TicketContent extends StatefulWidget {
  const TicketContent({super.key});

  @override
  State<TicketContent> createState() => _TicketContentState();
}

class _TicketContentState extends State<TicketContent> {
bool isTiketSelected = true;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tiketData = [
      {
        'from': 'Bandung',
        'to': 'Jakarta',
        'date': '3 Mei 2025',
        'time': '08:30 WIB',
        'bus': 'Java Express'
      },
    ];

    final List<Map<String, String>> riwayatData = [
      {
        'from': 'Surabaya',
        'to': 'Malang',
        'date': '10 April 2025',
        'time': '12:00 WIB',
        'bus': 'Bromo Trans'
      },
    ];

    final selectedData = isTiketSelected ? tiketData : riwayatData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiket Perjalanan'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isTiketSelected = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isTiketSelected ? Colors.orangeAccent : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Tiket',
                          style: TextStyle(
                            color: isTiketSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isTiketSelected = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !isTiketSelected ? Colors.orangeAccent : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Riwayat',
                          style: TextStyle(
                            color: !isTiketSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: selectedData.length,
              itemBuilder: (context, index) {
                final item = selectedData[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item['from']} → ${item['to']}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(item['date']!, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(item['time']!, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.directions_bus, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(item['bus']!, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        if (!isTiketSelected) ...[
                          const SizedBox(height: 6),
                          const Divider(),
                          const Text(
                            'Status: Selesai',
                            style: TextStyle(color: Colors.green),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}