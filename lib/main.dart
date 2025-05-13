import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:javabus/viewmodels/route_view_model.dart';
import 'package:javabus/views/screens/main/home_screen.dart';
import 'package:javabus/views/widgets/navbar.dart';
import 'package:provider/provider.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RouteViewModel()),
        ],
        child: const JavaBusApp(),
      ),
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
      home: const Navbar(),
      // initialRoute: '/',
      // routes: {
      //   '/page': (context) => const BottomNavbar(), 
      // }
    );
  }
}

