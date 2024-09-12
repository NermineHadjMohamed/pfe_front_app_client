import 'dart:convert';
import 'dart:developer';

import 'package:client_app/main.dart';
import 'package:client_app/models/cart.dart';
import 'package:client_app/models/category.dart';
import 'package:client_app/models/login_response_model.dart';
import 'package:client_app/models/product.dart';
import 'package:client_app/models/product_filter.dart';
import 'package:client_app/utils/shared_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

final apiService = Provider((ref) => APIService());

class APIService {
  static var client = http.Client();

  Future<List<Category>?> getCategories(page, pageSize) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    Map<String, String> queryString = {
      'page': page.toString(),
      'pageSize': pageSize.toString()
    };

    var url = Uri.https(Config.apiURL, Config.categoryAPI, queryString);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('succes to load categories. Response: ${response.body}');

      return categoriesFromJson(data["data"]);

      //return true;
    } else {
      print('Failed to load categories. Response: ${response.body}');
      return null;
    }
  }

  Future<List<Product>?> getProducts(
    ProductFilterModel productFilterModel,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    Map<String, String> queryString = {
      'page': productFilterModel.paginationModel.page.toString(),
      'pageSize': productFilterModel.paginationModel.pageSize.toString()
    };

    if (productFilterModel.categoryId != null) {
      queryString["categoryId"] = productFilterModel.categoryId!;
    }

    if (productFilterModel.sortBy != null) {
      queryString["sort"] = productFilterModel.sortBy!;
    }

    var url = Uri.https(Config.apiURL, Config.productAPI, queryString);
    try {
      var response = await client.get(
        url,
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("data $data");

        return productsFromJson(data["data"]);

        //return true;
      } else {
        return null;
      }
    } catch (error) {
      print("error $error");
    }
  }

  static Future<bool> registerUser(
    String fullName,
    String email,
    String password,
  ) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var url = Uri.https(Config.apiURL, Config.registerAPI);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {"fullName": fullName, "email": email, "password": password},
      ),
    );
    log(response.body.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> loginUser(
    String email,
    String password,
  ) async {
    Map<String, String> requestHeaders = {'Content-Type': "application/json"};

    var url = Uri.https(Config.apiURL, Config.loginAPI);
    var response = await client.post(url,
        headers: requestHeaders,
        body: jsonEncode({"email": email, "password": password}));
    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(loginResponseJson(response.body));
      return true;
    } else {
      return false;
    }
  }

  Future<Product?> getProductDetails(String productId) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.https(Config.apiURL, Config.productAPI + "/" + productId);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return Product.fromJson(data["data"]);
    } else {
      return null;
    }
  }

  Future<Cart?> getCart() async {
    print("hello 2");
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${loginDetails!.data.token.toString()}'
    };

    var url = Uri.https(Config.apiURL, Config.cartAPI);

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Cart.fromJson(data["data"]);
    } else if (response.statusCode == 401) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        "/login",
        (route) => false,
      );
    } else {
      return null;
    }
  }

  Future<bool?> addCartItem(productId, quantity) async {
    try {
      var loginDetails = await SharedService.loginDetails();

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${loginDetails!.data.token.toString()}'
      };

      var url = Uri.https(Config.apiURL, Config.cartAPI);

      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          {
            "products": [
              {
                "product": productId,
                "quantity": quantity,
              }
            ]
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          "/login",
          (route) => false,
        );
      } else {
        return null;
      }
    } catch (error) {
      print(error);
    }
  }

  Future<bool?> removeCartItem(productId, quantity) async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${loginDetails!.data.token.toString()}'
    };

    var url = Uri.https(Config.apiURL, Config.cartAPI);

    var response = await client.delete(
      url,
      headers: requestHeaders,
      body: jsonEncode(

          //"products":[
          {
            "productId": productId,
            "quantity": quantity,
          }
          //]

          ),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        "/login",
        (route) => false,
      );
    } else {
      return null;
    }
  }
Future<Map<String, dynamic>> createOrder(
    String userId,
    double grandTotal,
    String orderStatus,
    List<dynamic> products,
  ) async {
    var url = Uri.https(Config.apiURL, Config.orderAPI);
    var  response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'grandTotal': grandTotal,
        'orderStatus': orderStatus,
        'products': products,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create order');
    }
  }

  // Method to update an order
  Future<bool> updateOrder(String orderId, String transactionId) async {
    var url = Uri.https(Config.apiURL, Config.orderAPI);
    var response = await client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'status': 'Success',
        'transaction_id': transactionId,
      }),
    );

    return response.statusCode == 200;
  }
  
}