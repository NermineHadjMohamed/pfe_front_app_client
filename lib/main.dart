import 'package:client_app/pages/dashboard_page.dart';
import 'package:client_app/pages/home_page.dart';
import 'package:client_app/pages/login_page.dart';
import 'package:client_app/pages/order_success.dart';
import 'package:client_app/pages/payment_page.dart';
import 'package:client_app/pages/product_details_page.dart';
import 'package:client_app/pages/products_page.dart';
import 'package:client_app/pages/register_page.dart';
import 'package:client_app/utils/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Widget _defaultHome = const LoginPage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool _result = await SharedService.isLoggedIn();

  if (_result) {
    _defaultHome = const DashboardPage();
  }

  Stripe.publishableKey = "pk_test_51PrfdXAHaHhyZKufSazK9RvJ86eMCENnYEl25ZNjMnsp2MrbXIVhPZyGeVJc9j6Kol16kqo9uV7jYj9wg340AbTP00hvFt7cWc";
  await Stripe.instance.applySettings();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const RegisterPage(),
      navigatorKey: navigatorKey,
      routes: <String, WidgetBuilder>{
        '/': (context) => _defaultHome,
        '/register': (BuildContext context) => const RegisterPage(),
        '/home': (BuildContext context) => const HomePage(),
        '/login': (BuildContext context) => const LoginPage(),
        '/products': (BuildContext context) => const ProductsPage(),
        '/product-details': (BuildContext context) =>
            const ProductDetailsPage(),
        '/payments': (context) => const PaymentPage(),
        '/order-success': (context) => const OrderSuccess(),
      },
    );
  }
}
