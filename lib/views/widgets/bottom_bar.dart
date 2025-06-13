// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/views/screens/main/account_screen.dart';
import 'package:javabus/views/screens/main/home_screen.dart';
import 'package:javabus/views/screens/main/notification_screen.dart';
import 'package:javabus/views/screens/main/ticket_screen.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  void initState() {
    super.initState();
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    authVM.loadUserFromSession();
  }
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    HomeContent(),
    TicketContent(),
    NotificationContent(),
    AccountContent(),
  ];

  void _onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade50,
              Colors.white,
            ],
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.amber.shade50,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.shade200.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.amber.shade700,
            unselectedItemColor: Colors.grey.shade500,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.home_outlined, Icons.home, 0),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.airplane_ticket_outlined, Icons.airplane_ticket, 1),
                label: 'Tiketku',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.notifications_outlined, Icons.notifications, 2),
                label: 'Notifikasi',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.account_circle_outlined, Icons.account_circle_rounded, 3),
                label: 'Akun',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData unselectedIcon, IconData selectedIcon, int index) {
    bool isSelected = _selectedIndex == index;
    
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: EdgeInsets.all(isSelected ? 8 : 4),
      decoration: BoxDecoration(
        gradient: isSelected 
          ? LinearGradient(
              colors: [Colors.amber.shade400, Colors.orange.shade400],
            )
          : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected 
          ? [
              BoxShadow(
                color: Colors.amber.shade300.withOpacity(0.4),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ]
          : null,
      ),
      child: Icon(
        isSelected ? selectedIcon : unselectedIcon,
        color: isSelected ? Colors.white : Colors.grey.shade500,
        size: isSelected ? 26 : 24,
      ),
    );
  }
}