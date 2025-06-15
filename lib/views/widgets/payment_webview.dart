import 'package:flutter/material.dart';
import 'package:javabus/views/screens/main/home_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatelessWidget {
  final String url;

  const PaymentWebView({super.key, required this.url});

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (!didPop) {
          _navigateToHome(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pembayaran'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _navigateToHome(context);
            },
          ),
        ),
        body: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(url)),
        ),
      ),
    );
  }
}
