// ignore_for_file: deprecated_member_use
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:javabus/helpers/session_helper.dart';
import 'package:javabus/models/user.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/viewmodels/booking_view_model.dart';
import 'package:javabus/viewmodels/bus_view_model.dart';
import 'package:javabus/viewmodels/payment_view_model.dart';
import 'package:javabus/viewmodels/route_view_model.dart';
import 'package:javabus/viewmodels/schedule_view_model.dart';
import 'package:javabus/views/screens/auth/login_screen.dart';
import 'package:javabus/views/screens/auth/register_screen.dart';
import 'package:javabus/views/screens/sub_admin/sub_admin_screen.dart';
import 'package:javabus/views/widgets/admin_navbar.dart';
import 'package:javabus/views/widgets/navbar.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await SessionHelper.isLoggedIn();
  final user = isLoggedIn ? await SessionHelper.getUser() : null;
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RouteViewModel()),
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => BusViewModel()),
          ChangeNotifierProvider(create: (_) => PaymentViewModel()),
          ChangeNotifierProvider(create: (_) => BookingViewModel()),
          ChangeNotifierProvider(create: (_) => ScheduleViewModel()),
        ],
        child: JavaBusApp(user: user),
      ),
    ),
  );
}

class JavaBusApp extends StatelessWidget {
  final User? user;
  const JavaBusApp({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Widget homeWidget;

    if (user == null) {
      homeWidget = const LoginScreen();
    } else {
      switch (user!.roleId) {
        case 1:
          homeWidget = const AdminNavbar();
          break;
        case 2:
          homeWidget = const SubAdminScreen();
          break;
        case 3:
      default:
          homeWidget = const Navbar();
      }
    }


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: homeWidget,
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const Navbar(),
        '/admin': (context) => const AdminNavbar(),
        '/subadmin': (context) => const SubAdminScreen(),
      },
    );
  }
}

