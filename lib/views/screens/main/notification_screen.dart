import 'package:flutter/material.dart';
import 'package:javabus/views/widgets/bottom_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override


  Widget build(BuildContext context) {
    return BottomBar();
  }
}

class NotificationContent extends StatefulWidget {
  const NotificationContent({super.key});

  @override
  State<NotificationContent> createState() => _NotificationContentState();
}

class _NotificationContentState extends State<NotificationContent> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}