import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:javabus/views/screens/admin/admin_home_screen.dart';
import 'package:javabus/views/screens/auth/login_screen.dart';
import 'package:javabus/views/screens/home_screen.dart';
import 'package:javabus/views/widgets/admin_navbar.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const JavaBusApp(),
    ),
  );
}

class JavaBusApp extends StatelessWidget {
  const JavaBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ignore: deprecated_member_use
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      // theme: ThemeData.light(),
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const AdminNavbar(),
      // initialRoute: '/',
      // routes: {
      //   '/page': (context) => const BottomNavbar(), 
      // }
    );
  }
}

