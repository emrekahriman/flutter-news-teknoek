import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:teknoek/screens/discover.dart';
import 'package:teknoek/screens/home.dart';
import 'package:teknoek/screens/profile.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: widget.index,
      backgroundColor: Colors.transparent,
      color: Color(0xff222324),
      animationDuration: const Duration(milliseconds: 300),
      onTap: (i) {
        if (i != widget.index) {
          if (i == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const Home()));
          }
          if (i == 1) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Discover()));
          }
          if (i == 2) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Profile()));
          }
        }
      },
      items: const [
        Icon(
          Icons.home,
          color: Colors.white,
        ),
        Icon(
          Icons.search,
          color: Colors.white,
        ),
        Icon(
          Icons.person,
          color: Colors.white,
        ),
      ],
    );
  }
}
