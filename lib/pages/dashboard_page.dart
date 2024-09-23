import 'package:client_app/pages/cart_page.dart';
import 'package:client_app/pages/home_page.dart';
import 'package:client_app/pages/orderList_page.dart';
import 'package:client_app/pages/login_page.dart'; // Import your login page
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    HomePage(),
  ];
  int index = 0;

  void _logout() async {
    // Implement your logout logic here (e.g., clear tokens, etc.)
    // Example: await AuthService.logout();

    // Navigate to the login page
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
        title: Text('Client Application'),
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
