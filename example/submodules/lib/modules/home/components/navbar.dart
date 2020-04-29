import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/home_model.dart';

class Navbar extends StatelessWidget {
  final HomeModel model;
  
  Navbar(this.model);

  @override
  Widget build(BuildContext context) =>
    BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: this.model.onTapMenuItem,
      currentIndex: this.model.selectedIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("NewsFeed"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.traffic),
          title: Text("Func A"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tv),
          title: Text("Func B"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.power),
          title: Text("Logout"),
        ),
      ],
    );
}