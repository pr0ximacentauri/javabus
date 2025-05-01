import 'package:flutter/material.dart';
import 'package:javabus/views/widgets/navbar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Navbar();
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}


class _HomeContentState extends State<HomeContent> {
  String fromLocation = 'Jember';
  String toLocation = 'Surabaya';

  void swapLocations() {
    setState(() {
      final temp = fromLocation;
      fromLocation = toLocation;
      toLocation = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/5987/5987424.png'),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Selamat Datang, User!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
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
                          value: fromLocation,
                          onTap: () {
                          },
                        ),
                        locationButton(
                          icon: Icons.location_on,
                          label: "Tujuan",
                          value: toLocation,
                          onTap: () {
                          },
                        ),
                        locationButton(
                          icon: Icons.date_range,
                          label: "Tanggal Keberangkatan",
                          value: "Kam 1-Mei",
                          onTap: () {
                          },
                        ),
                      ],
                    ),
                    Positioned(
                      right: 16,
                      top: 46,
                      child: GestureDetector(
                        onTap: swapLocations,
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
              onPressed: () {
              },
              icon: const Icon(Icons.search, color: Colors.black,),
              label: const Text("Cari bus", style: TextStyle(color: Colors.black),),
            ),

            SizedBox(height: 20),
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 4,
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
                  onTap: () => print('Terminal tapped'),
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
                  onTap: () => print('Bantuan tapped'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text('Rekomendasi Tempat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 200,
              width: 350,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  Card(
                    color: Colors.brown,
                    child: Column(
                      children: [
                        Image.network(
                          'https://picsum.photos/id/11/300/150',
                          fit: BoxFit.cover,
                        ),
                        Text('Yogyakarta')
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.blue,
                    child: Column(
                      children: [
                        Image.network(
                          'https://picsum.photos/id/12/300/150',
                          fit: BoxFit.cover,
                        ),
                        Text('Banyuwangi')
                      ],
                    ),
                  )
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