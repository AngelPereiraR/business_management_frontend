// To parse this JSON data, do
//
//     final order = orderFromMap(jsonString);

import 'dart:convert';

import '../models/models.dart';

class Order {
  int id;
  double finalPrice;
  String company;
  String user;
  List<dynamic> quantities;
  List<Product> products;

  Order({
    required this.id,
    required this.finalPrice,
    required this.company,
    required this.user,
    required this.quantities,
    required this.products,
  });

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  factory Order.fromMap(Map<String, dynamic> json) => Order(
        id: json["id"],
        finalPrice: json["finalPrice"]?.toDouble(),
        company: json["companyName"],
        user: json["userUsername"],
        quantities: List<dynamic>.from(json["quantities"].map((x) => x)),
        products:
            List<Product>.from(json["products"].map((x) => Product.fromMap(x))),
      );
}
