// To parse this JSON data, do
//
//     final Product = ProductFromMap(jsonString);

import 'dart:convert';

class Product {
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  int id;
  String name;
  String description;
  double price;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
      };
}
