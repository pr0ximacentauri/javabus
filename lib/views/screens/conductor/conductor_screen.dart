import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:javabus/viewmodels/ticket_view_model.dart';

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

    if (code != null) {
      setState(() {
        isScanning = false;
        scannedResult = code;
      });

      final ticketId = int.tryParse(code);
      if (ticketId == null) {
        _showSnackbar('QR Code tidak valid');
        setState(() => isScanning = true);
        return;
      }

      final ticketVM = Provider.of<TicketViewModel>(context, listen: false);
      final success = await ticketVM.updateTicketStatus(ticketId, 'selesai');

      if (success) {
        _showSnackbar('Tiket berhasil diverifikasi');
      } else {
        _showSnackbar('Gagal memperbarui status tiket');
      }

      await Future.delayed(const Duration(seconds: 2));
      setState(() => isScanning = true);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Tiket')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
            ),
          ),
          if (scannedResult != null)
            Expanded(
              flex: 1,
              child: Center(
                child: Text('Hasil Scan: $scannedResult'),
              ),
            ),
        ],
      ),
    );
  }
}
