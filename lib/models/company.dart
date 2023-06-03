// To parse this JSON data, do
//
//     final company = companyFromMap(jsonString);

import 'dart:convert';

class Company {
  int id;
  String name;
  String description;
  List<ProductCompany> products;
  List<CategoryCompany> categories;
  List<dynamic> suggestions;

  Company({
    required this.id,
    required this.name,
    required this.description,
    required this.products,
    required this.categories,
    required this.suggestions,
  });

  factory Company.fromJson(String str) => Company.fromMap(json.decode(str));

  factory Company.fromMap(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        products: List<ProductCompany>.from(
            json["products"].map((x) => CategoryCompany.fromMap(x))),
        categories: List<CategoryCompany>.from(
            json["categories"].map((x) => CategoryCompany.fromMap(x))),
        suggestions: List<dynamic>.from(json["suggestions"].map((x) => x)),
      );
}

class CategoryCompany {
  int id;
  String name;
  String description;

  CategoryCompany({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CategoryCompany.fromJson(String str) =>
      CategoryCompany.fromMap(json.decode(str));

  factory CategoryCompany.fromMap(Map<String, dynamic> json) => CategoryCompany(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );
}

class ProductCompany {
  int id;
  String name;
  String description;
  double price;

  ProductCompany({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory ProductCompany.fromJson(String str) =>
      ProductCompany.fromMap(json.decode(str));

  factory ProductCompany.fromMap(Map<String, dynamic> json) => ProductCompany(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
      );
}
