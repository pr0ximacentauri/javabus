import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:javabus/helpers/session_helper.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/viewmodels/bus_view_model.dart';
import 'package:javabus/viewmodels/payment_view_model.dart';
import 'package:javabus/viewmodels/route_view_model.dart';
import 'package:javabus/views/screens/auth/login_screen.dart';
import 'package:javabus/views/screens/auth/register_screen.dart';
import 'package:javabus/views/widgets/navbar.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await SessionHelper.isLoggedIn();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RouteViewModel()),
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => BusViewModel()),
          ChangeNotifierProvider(create: (_) => PaymentViewModel()),
        ],
        child: JavaBusApp(isLoggedIn : isLoggedIn),
      ),
    ),
  );
}

class JavaBusApp extends StatelessWidget {
  final bool isLoggedIn;
  const JavaBusApp({super.key, required this.isLoggedIn});

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
      home: isLoggedIn ? const Navbar() : const LoginScreen(),
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const Navbar(), 
      }
    );
  }
}

