// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:javabus/viewmodels/ticket_view_model.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';

class ConductorScreen extends StatefulWidget {
  const ConductorScreen({super.key});

  @override
  State<ConductorScreen> createState() => _ConductorScreenState();
}

class _ConductorScreenState extends State<ConductorScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool isScanning = true;
  String? scannedResult;

  void _onDetect(BarcodeCapture capture) async {
    if (!isScanning) return;

    final barcode = capture.barcodes.first;
    final code = barcode.rawValue;

    if (code == null) {
      _showSnackbar('QR Code tidak terbaca');
      return;
    }

    final ticketId = int.tryParse(code);
    if (ticketId == null) {
      _showSnackbar('QR Code tidak valid');
      return;
    }

    setState(() {
      isScanning = false;
      scannedResult = code;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final ticketVM = Provider.of<TicketViewModel>(context, listen: false);
    final success = await ticketVM.updateTicketStatus(ticketId, 'selesai');

    Navigator.pop(context);

    if (success) {
      _showSnackbar('Tiket berhasil diverifikasi');
    } else {
      _showSnackbar(ticketVM.msg ?? 'Gagal memverifikasi tiket');
    }

    await Future.delayed(const Duration(seconds: 2));
    setState(() => isScanning = true);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _onLogoutTap() async {
    final confirmLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 28),
            const SizedBox(width: 8),
            const Text("Konfirmasi"),
          ],
        ),
        content: const Text("Apakah kamu yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            child: const Text("Batal"),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.red, Colors.redAccent]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text("Logout"),
            ),
          ),
        ],
      ),
    );

    if (confirmLogout == true) {
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      await authVM.logout();
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildScannerOverlay() {
    return Stack(
      children: [
        Container(color: Colors.black.withOpacity(0.4)),
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Tiket'),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            onPressed: _onLogoutTap,
            icon: const Icon(Icons.logout),
            color: Colors.red,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
                _buildScannerOverlay(),
              ],
            ),
          ),
          if (scannedResult != null)
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hasil Scan: $scannedResult'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        scannedResult = null;
                        isScanning = true;
                      });
                    },
                    child: const Text("Scan Ulang"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
