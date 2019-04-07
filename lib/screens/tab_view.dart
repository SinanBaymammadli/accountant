import 'package:accountant/screens/client/client_list.dart';
import 'package:accountant/screens/dashboard/dashboard.dart';
import 'package:accountant/screens/order/order_list.dart';
import 'package:accountant/screens/payment/payment_list.dart';
import 'package:accountant/screens/product/product_list.dart';
import 'package:flutter/material.dart';

class TabView extends StatefulWidget {
  final Widget child;

  TabView({Key key, this.child}) : super(key: key);

  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  static int startTabIndex = 0;
  int _currentTabIndex = startTabIndex;

  final List<Widget> _tabs = [
    DashboardScreen(),
    OrderListScreen(),
    ClientListScreen(),
    PaymentListScreen(),
    ProductListScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(child: _tabs[_currentTabIndex]),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentTabIndex,
            onTap: _onTabTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                title: Text(
                  "Statistika",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.airport_shuttle),
                title: Text(
                  "Alqi-Satgi",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text(
                  "Klientler",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money),
                title: Text(
                  "Odeme",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bubble_chart),
                title: Text(
                  "Mallar",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
