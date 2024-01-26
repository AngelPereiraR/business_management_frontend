// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import '../services/services.dart';

class UpdateServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl =
      'https://business-management-api-angelpereira.koyeb.app/';

  UpdateServices();

  updateCategory(int? idCompany, int? idCategory, String? name,
      String? description) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.put(
        "$_baseUrl/api/company/$idCompany/categories/$idCategory",
        body: {'id': idCategory, 'name': name, 'description': description},
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> updateCategory =
        json.decode(utf8.decode(response.bodyBytes));
    if (updateCategory.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO UPDATE CATEGORY. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }

  updateProduct(int? idCompany, int? idCategory, int? idProduct, String? name,
      String? description, double? price) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.put(
        "$_baseUrl/api/company/$idCompany/categories/$idCategory/products/$idProduct",
        body: {
          'id': idProduct,
          'name': name,
          'description': description,
          'price': price
        },
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> updateProduct =
        json.decode(utf8.decode(response.bodyBytes));
    if (updateProduct.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO UPDATE PRODUCT. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }

  updateCompany(int? id, String? name, String? description) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.put("$_baseUrl/api/company/companies/$id",
        body: {
          'id': id,
          'name': name,
          'description': description,
        },
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> updateCompany =
        json.decode(utf8.decode(response.bodyBytes));
    if (updateCompany.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO UPDATE COMPANY. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }

  updateSuggestion(int? id, int? idSuggestion, String? commentary,
      String? state, String? username) async {
    String? token = await LoginServices().readToken();

    var response = await Requests.put(
        "$_baseUrl/api/companies/$id/suggestions/$username/$idSuggestion",
        body: {
          'id': idSuggestion,
          'commentary': commentary,
          'state': state,
          'username': username,
        },
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> updateSuggestion =
        json.decode(utf8.decode(response.bodyBytes));
    if (updateSuggestion.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO UPDATE SUGGESTION. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }

  activateOrDeactivate(String? username) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.put("$_baseUrl/api/users/$username",
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> updateUser =
        json.decode(utf8.decode(response.bodyBytes));
    if (updateUser.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO UPDATE COMPANY. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }

  acceptSuggestion(int suggestionId) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.put(
        "$_baseUrl/api/suggestions/$suggestionId/accept",
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> updateUser =
        json.decode(utf8.decode(response.bodyBytes));
    if (updateUser.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO ACCEPT SUGGESTION. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }

  denegateSuggestion(int suggestionId) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.put(
        "$_baseUrl/api/suggestions/$suggestionId/denegate",
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> updateUser =
        json.decode(utf8.decode(response.bodyBytes));
    if (updateUser.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO DENEGATE SUGGESTION. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }

  likeSuggestion(int suggestionId, String? username) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.put(
        "$_baseUrl/api/suggestions/$suggestionId/like/$username",
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> updateUser =
        json.decode(utf8.decode(response.bodyBytes));
    if (updateUser.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO ACCEPT SUGGESTION. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }

  dislikeSuggestion(int suggestionId, String? username) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.put(
        "$_baseUrl/api/suggestions/$suggestionId/dislike/$username",
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> updateUser =
        json.decode(utf8.decode(response.bodyBytes));
    if (updateUser.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO DENEGATE SUGGESTION. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }

  insertProductIntoOrder(int? orderId, int? productId, String? quantity) async {
    String? token = await LoginServices().readToken();

    var response = await Requests.put(
        "$_baseUrl/api/orders/$orderId/product/$productId/$quantity",
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> insertOrder =
        json.decode(utf8.decode(response.bodyBytes));
    if (insertOrder.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO INSERT ORDER. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }
}
