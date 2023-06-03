// To parse this JSON data, do
//
//     final Product = ProductFromMap(jsonString);

import '../models/models.dart';
import 'dart:convert';

class ProductCart {
  ProductCart(this.product, this.quantity) {
    calcularTotal();
  }

  void calcularTotal() {
    totalPrice = product.price * quantity;
  }

  Product product;
  int quantity;
  late double totalPrice;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": product.toJson(),
        "quantity": quantity,
        "totalPrice": totalPrice,
      };
}
