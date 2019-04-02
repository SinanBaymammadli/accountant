import 'package:accountant/screens/client/client_list.dart';
import 'package:accountant/screens/dashboard/dashboard.dart';
import 'package:accountant/screens/order/order_list.dart';
import 'package:accountant/screens/product/product_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabView extends StatefulWidget {
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text("Statistika"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airport_shuttle),
            title: Text("Alqi-Satgi"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Klientler"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart),
            title: Text("Mallar"),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return DashboardScreen();
            break;
          case 1:
            return OrderListScreen();
            break;
          case 2:
            return ClientListScreen();
            break;
          case 3:
            return ProductListScreen();
            break;
          default:
            return OrderListScreen();
        }
      },
    );
  }
}
