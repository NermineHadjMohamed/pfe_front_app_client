import 'package:client_app/pages/cart_page.dart';
import 'package:client_app/pages/home_page.dart';
import 'package:client_app/pages/orderList_page.dart';
import 'package:client_app/pages/login_page.dart';
import 'package:client_app/pages/user_profile_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Widget> widgetList = [
    HomePage(),
    CartPage(),
    OrderListPage(),
    UserProfilePage(),
  ];
  int index = 0;

  void _logout() async {

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.business_center, size: 26), // Icon for the title
            SizedBox(width: 8), // Space between icon and text
            Text(
              'Client Application',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (_index) {
          setState(() {
            index = _index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket), label: "Store"),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Order list",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle), label: "My Account"),
        ],
      ),
      body: widgetList[index],
    );
  }
}
