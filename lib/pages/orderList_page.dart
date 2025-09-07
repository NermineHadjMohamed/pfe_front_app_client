import 'package:flutter/material.dart';
import 'package:client_app/models/order.dart'; 
import 'package:client_app/api/api_service.dart'; 
import 'package:intl/intl.dart'; 
import 'orderDetails_page.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<Order>? orders;

  @override
  void initState() {
    super.initState();
    getOrders(); 
  }

  Future<void> getOrders() async {
    final apiService = APIService();
    orders = await apiService.getOrders(); 

    setState(() {});
  }

  Color _getStatusColor(String status) {
    return Colors.blue; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order List"),
        backgroundColor: Colors.teal,
      ),
      body: orders == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: orders!.map((order) {
                  final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(order.createdAt);
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: ListTile(
                      title: Text("Order ID: ${order.id}", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status: ${order.orderStatus}",
                            style: TextStyle(color: _getStatusColor(order.orderStatus)),
                          ),
                          Text("Created At: $formattedDate"),
                          SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.teal,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailsPage(),
                                  settings: RouteSettings(arguments: order),
                                ),
                              );
                            },
                            child: Text("View Details"),
                          ),
                        ],
                      ),
                      trailing: Text("Total: ${order.grandTotal} TND", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
