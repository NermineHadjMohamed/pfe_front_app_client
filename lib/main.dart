import 'package:client_app/pages/dashboard_page.dart';
import 'package:client_app/pages/home_page.dart';
import 'package:client_app/pages/login_page.dart';
import 'package:client_app/pages/orderDetails_page.dart';
import 'package:client_app/pages/orderList_page.dart';
import 'package:client_app/pages/order_success.dart';
import 'package:client_app/pages/product_details_page.dart';
import 'package:client_app/pages/products_page.dart';
import 'package:client_app/pages/register_page.dart';
import 'package:client_app/pages/user_profile_page.dart';
import 'package:client_app/utils/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Widget _defaultHome = const LoginPage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool _result = await SharedService.isLoggedIn();

  if (_result) {
    _defaultHome = const DashboardPage();
  }

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SharedService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final bool isLoggedIn = snapshot.data ?? false;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          navigatorKey: navigatorKey,
          routes: <String, WidgetBuilder>{
            '/': (context) =>
                isLoggedIn ? const DashboardPage() : const LoginPage(),
            '/register': (BuildContext context) => const RegisterPage(),
            '/home': (BuildContext context) => const HomePage(),
            '/login': (BuildContext context) => const LoginPage(),
            '/products': (BuildContext context) => const ProductsPage(),
            '/product-details': (BuildContext context) =>
                const ProductDetailsPage(),
            '/order-success': (context) => const OrderSuccess(),
            '/order-details': (context) => const OrderDetailsPage(),
            '/order-list': (context) => OrderListPage(),
            '/user-profile': (BuildContext context) => UserProfilePage(),
          },
        );
      },
    );
  }
}
