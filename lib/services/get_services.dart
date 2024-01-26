// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import '../services/services.dart';
import '../models/models.dart';

class GetServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl =
      'https://business-management-api-angelpereira.koyeb.app';

  List<Category> categories = [];

  bool isLoading = true;

  GetServices();

  List<Company> companies = [];

  getCompanies() async {
    companies.clear();
    String? token = await LoginServices().readToken();
    var response = await Requests.get("$_baseUrl/api/companies",
        headers: {'Authorization': 'Bearer $token'});

    isLoading = true;
    notifyListeners();

    int idCompany = 0;
    String nameCompany = "";
    String descriptionCompany = "";
    List<ProductCompany> products = [];
    List<CategoryCompany> categories = [];
    List<dynamic> suggestions = [];

    int idProduct = 0;
    String nameProduct = "";
    String descriptionProduct = "";
    double price = 0;

    int idCategory = 0;
    String nameCategory = "";
    String descriptionCategory = "";

    var resp;
    if (response.body.isNotEmpty) {
      final List<dynamic> companiesResponse =
          json.decode(utf8.decode(response.bodyBytes));
      for (int i = 0; i < companiesResponse.length; i++) {
        if (companiesResponse[i].containsKey("id")) {
          companiesResponse[i].forEach((key, value) {
            if (key == "id") {
              idCompany = value;
            } else if (key == "name") {
              nameCompany = value;
            } else if (key == "description") {
              descriptionCompany = value;
            } else if (key == "products") {
              for (int j = 0; j < value.length; j++) {
                value[j].forEach((key, value) {
                  if (key == "id") {
                    idProduct = value;
                  } else if (key == "name") {
                    nameProduct = value;
                  } else if (key == "description") {
                    descriptionProduct = value;
                  } else if (key == "price") {
                    price = value;
                    products.add(ProductCompany(
                        id: idProduct,
                        name: nameProduct,
                        description: descriptionProduct,
                        price: price));
                  }
                });
              }
            } else if (key == "categories") {
              for (int j = 0; j < value.length; j++) {
                value[j].forEach((key, value) {
                  if (key == "id") {
                    idCategory = value;
                  } else if (key == "name") {
                    nameCategory = value;
                  } else if (key == "description") {
                    descriptionCategory = value;
                    categories.add(CategoryCompany(
                        id: idCategory,
                        name: nameCategory,
                        description: descriptionCategory));
                  }
                });
              }
            } else if (key == "suggestions") {
              suggestions = value;

              Company company = Company(
                  id: idCompany,
                  name: nameCompany,
                  description: descriptionCompany,
                  products: products,
                  categories: categories,
                  suggestions: suggestions);

              companies.add(company);
            }
          });
        } else {
          String? error = '';

          error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

          resp = error;
        }
      }

      resp = companies;

      isLoading = false;
      notifyListeners();
      return resp;
    }

    isLoading = false;
    notifyListeners();
    return resp;
  }

  Company? company;

  getCompanyFromUser(String? username) async {
    companies.clear();
    String? token = await LoginServices().readToken();
    var response = await Requests.get(
        "$_baseUrl/api/company/companies/$username",
        headers: {'Authorization': 'Bearer $token'});

    isLoading = true;
    notifyListeners();

    int idCompany = 0;
    String nameCompany = "";
    String descriptionCompany = "";
    List<ProductCompany> products = [];
    List<CategoryCompany> categories = [];
    List<dynamic> suggestions = [];

    int idProduct = 0;
    String nameProduct = "";
    String descriptionProduct = "";
    double price = 0;

    int idCategory = 0;
    String nameCategory = "";
    String descriptionCategory = "";

    var resp;
    if (response.body.isNotEmpty) {
      final Map<String, dynamic> companyResponse =
          json.decode(utf8.decode(response.bodyBytes));
      if (companyResponse.containsKey("id")) {
        companyResponse.forEach((key, value) {
          if (key == "id") {
            idCompany = value;
          } else if (key == "name") {
            nameCompany = value;
          } else if (key == "description") {
            descriptionCompany = value;
          } else if (key == "products") {
            for (int j = 0; j < value.length; j++) {
              value[j].forEach((key, value) {
                if (key == "id") {
                  idProduct = value;
                } else if (key == "name") {
                  nameProduct = value;
                } else if (key == "description") {
                  descriptionProduct = value;
                } else if (key == "price") {
                  price = value;
                  products.add(ProductCompany(
                      id: idProduct,
                      name: nameProduct,
                      description: descriptionProduct,
                      price: price));
                }
              });
            }
          } else if (key == "categories") {
            for (int j = 0; j < value.length; j++) {
              value[j].forEach((key, value) {
                if (key == "id") {
                  idCategory = value;
                } else if (key == "name") {
                  nameCategory = value;
                } else if (key == "description") {
                  descriptionCategory = value;
                  categories.add(CategoryCompany(
                      id: idCategory,
                      name: nameCategory,
                      description: descriptionCategory));
                }
              });
            }
          } else if (key == "suggestions") {
            suggestions = value;

            company = Company(
                id: idCompany,
                name: nameCompany,
                description: descriptionCompany,
                products: products,
                categories: categories,
                suggestions: suggestions);
          }
        });
      } else {
        String? error = '';

        error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

        resp = error;
      }

      resp = company;

      isLoading = false;
      notifyListeners();
      return resp;
    }

    isLoading = false;
    notifyListeners();
    return resp;
  }

  getCategories(int? id) async {
    categories.clear();
    String? token = await LoginServices().readToken();
    var response = await Requests.get("$_baseUrl/api/company/$id/categories",
        headers: {'Authorization': 'Bearer $token'});

    isLoading = true;
    notifyListeners();

    int idCategory = 0;
    String nameCategory = "";
    String descriptionCategory = "";

    var resp;
    if (response.body.isNotEmpty) {
      final List<dynamic> categoriesResponse =
          json.decode(utf8.decode(response.bodyBytes));
      for (int i = 0; i < categoriesResponse.length; i++) {
        if (categoriesResponse[i].containsKey("id")) {
          categoriesResponse[i].forEach((key, value) {
            if (key == "id") {
              idCategory = value;
            } else if (key == "name") {
              nameCategory = value;
            } else if (key == "description") {
              descriptionCategory = value;

              Category category = Category(
                  id: idCategory,
                  name: nameCategory,
                  description: descriptionCategory);

              categories.add(category);
            }
          });
        } else {
          String? error = '';

          error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

          resp = error;
        }
      }

      resp = categories;

      isLoading = false;
      notifyListeners();
      return resp;
    }

    isLoading = false;
    notifyListeners();
    return resp;
  }

  Category? category;

  getCategory(int? id) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.get("$_baseUrl/api/user/categories/$id",
        headers: {'Authorization': 'Bearer $token'});

    int idCategory = 0;
    String nameCategory = "";
    String descriptionCategory = "";

    var resp;
    if (response.body.isNotEmpty) {
      final Map<String, dynamic> getProducts =
          json.decode(utf8.decode(response.bodyBytes));
      if (getProducts.containsKey("id")) {
        getProducts.forEach((key, value) {
          if (key == "id") {
            idCategory = value;
          } else if (key == "name") {
            nameCategory = value;
          } else if (key == "description") {
            descriptionCategory = value;
            category = Category(
                id: idCategory,
                name: nameCategory,
                description: descriptionCategory);
          }
        });
      } else {
        String? error = '';

        error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

        resp = error;
      }

      resp = category;

      return resp;
    }
  }

  List<Product> products2 = [];

  getProductsFromCategory(int? id) async {
    products2.clear();
    String? token = await LoginServices().readToken();
    var response = await Requests.get("$_baseUrl/api/categories/$id/products",
        headers: {'Authorization': 'Bearer $token'});

    isLoading = true;
    notifyListeners();

    int idProduct = 0;
    String name = "";
    String description = "";
    double price = 0;

    var resp;
    if (response.body.isNotEmpty) {
      final List<dynamic> getProducts =
          json.decode(utf8.decode(response.bodyBytes));
      for (int i = 0; i < getProducts.length; i++) {
        if (getProducts[i].containsKey("id")) {
          getProducts[i].forEach((key, value) {
            if (key == "id") {
              idProduct = value;
            } else if (key == "name") {
              name = value;
            } else if (key == "description") {
              description = value;
            } else if (key == "price") {
              price = value;
              products2.add(Product(
                  id: idProduct,
                  name: name,
                  description: description,
                  price: price));
            }
          });
        } else {
          String? error = '';

          error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

          resp = error;
        }
      }

      resp = products2;
      isLoading = false;
      notifyListeners();
      return resp;
    }

    isLoading = false;
    notifyListeners();
    return resp;
  }

  List<Product> products3 = [];

  getProductsFromCompany(int? id) async {
    products3.clear();
    String? token = await LoginServices().readToken();
    var response = await Requests.get("$_baseUrl/api/companies/$id/products",
        headers: {'Authorization': 'Bearer $token'});

    isLoading = true;
    notifyListeners();

    int idProduct = 0;
    String name = "";
    String description = "";
    double price = 0;

    var resp;
    if (response.body.isNotEmpty) {
      final List<dynamic> getProducts =
          json.decode(utf8.decode(response.bodyBytes));
      for (int i = 0; i < getProducts.length; i++) {
        if (getProducts[i].containsKey("id")) {
          getProducts[i].forEach((key, value) {
            if (key == "id") {
              idProduct = value;
            } else if (key == "name") {
              name = value;
            } else if (key == "description") {
              description = value;
            } else if (key == "price") {
              price = value;
              products3.add(Product(
                  id: idProduct,
                  name: name,
                  description: description,
                  price: price));
            }
          });
        } else {
          String? error = '';

          error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

          resp = error;
        }
      }

      resp = products3;
      isLoading = false;
      notifyListeners();
      return resp;
    }

    isLoading = false;
    notifyListeners();
    return resp;
  }

  List<Suggestion> suggestions = [];

  getSuggestionsFromCompany(int? id) async {
    suggestions.clear();
    String? token = await LoginServices().readToken();
    var response = await Requests.get("$_baseUrl/api/companies/$id/suggestions",
        headers: {'Authorization': 'Bearer $token'});

    isLoading = true;
    notifyListeners();

    int idFavorite = 0;

    int idUser = 0;
    String email = "";
    String usernameUser = "";
    String password = "";
    String role = "";
    bool enabled = false;

    var resp;
    if (response.body.isNotEmpty) {
      final List<dynamic> getSuggestions =
          json.decode(utf8.decode(response.bodyBytes));
      for (int i = 0; i < getSuggestions.length; i++) {
        int idSuggestion = 0;
        String commentary = "";
        String state = "";
        String username = "";

        if (getSuggestions[i].containsKey("id")) {
          List<Favorite> favorite = [];
          List<UserLike> userLikes = [];
          List<UserLike> userDislikes = [];
          getSuggestions[i].forEach((key, value) {
            if (key == "id") {
              idSuggestion = value;
            } else if (key == "commentary") {
              commentary = value;
            } else if (key == "state") {
              state = value;
            } else if (key == "username") {
              username = value;
            } else if (key == "favorite") {
              for (int j = 0; j < value.length; j++) {
                if (value[j].containsKey("id")) {
                  value[j].forEach((key2, value2) {
                    if (key2 == "id") {
                      idFavorite = value2;
                    } else if (key2 == "userLikes") {
                      for (int k = 0; k < value2.length; k++) {
                        if (value2[k].containsKey("id")) {
                          value2[k].forEach((key3, value3) {
                            if (key3 == "id") {
                              idUser = value3;
                            } else if (key3 == "email") {
                              email = value3;
                            } else if (key3 == "username") {
                              usernameUser = value3;
                            } else if (key3 == "password") {
                              password = value3;
                            } else if (key3 == "role") {
                              role = value3;
                            } else if (key3 == "enabled") {
                              enabled = value3;
                              userLikes.add(UserLike(
                                  id: idUser,
                                  email: email,
                                  username: usernameUser,
                                  password: password,
                                  role: role,
                                  enabled: enabled));
                            }
                          });
                        }
                      }
                    } else if (key2 == "userDislikes") {
                      for (int k = 0; k < value2.length; k++) {
                        if (value2[k].containsKey("id")) {
                          value2[k].forEach((key3, value3) {
                            if (key3 == "id") {
                              idUser = value3;
                            } else if (key3 == "email") {
                              email = value3;
                            } else if (key3 == "username") {
                              usernameUser = value3;
                            } else if (key3 == "password") {
                              password = value3;
                            } else if (key3 == "role") {
                              role = value3;
                            } else if (key3 == "enabled") {
                              enabled = value3;
                              userDislikes.add(UserLike(
                                  id: idUser,
                                  email: email,
                                  username: usernameUser,
                                  password: password,
                                  role: role,
                                  enabled: enabled));
                            }
                          });
                        }
                      }
                    }
                  });
                }
              }
            }
            favorite.add(Favorite(
                id: idFavorite,
                userLikes: userLikes,
                userDislikes: userDislikes));
          });
          suggestions.add(Suggestion(
              id: idSuggestion,
              commentary: commentary,
              state: state,
              username: username,
              favorite: favorite));
        } else {
          String? error = '';

          error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

          resp = error;
        }
      }

      resp = suggestions;
      isLoading = false;
      notifyListeners();
      return resp;
    }

    isLoading = false;
    notifyListeners();
    return resp;
  }

  List<User> users = [];

  getUsers() async {
    users.clear();
    String? token = await LoginServices().readToken();
    var response = await Requests.get("$_baseUrl/api/users",
        headers: {'Authorization': 'Bearer $token'});

    isLoading = true;
    notifyListeners();

    int idUser = 0;
    String email = "";
    String username = "";
    String password = "";
    String role = "";
    bool enabled = false;
    dynamic tokenUser;

    var resp;
    if (response.body.isNotEmpty) {
      final List<dynamic> usersResponse =
          json.decode(utf8.decode(response.bodyBytes));
      for (int i = 0; i < usersResponse.length; i++) {
        if (usersResponse[i].containsKey("id")) {
          usersResponse[i].forEach((key, value) {
            if (key == "id") {
              idUser = value;
            } else if (key == "email") {
              email = value;
            } else if (key == "username") {
              username = value;
            } else if (key == "password") {
              password = value;
            } else if (key == "role") {
              role = value;
            } else if (key == "enabled") {
              enabled = value;
            } else if (key == "token") {
              tokenUser = value;

              User user = User(
                  id: idUser,
                  email: email,
                  username: username,
                  password: password,
                  role: role,
                  enabled: enabled,
                  token: tokenUser);

              users.add(user);
            }
          });
        } else {
          String? error = '';

          error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

          resp = error;
        }
      }

      resp = users;

      isLoading = false;
      notifyListeners();
      return resp;
    }

    isLoading = false;
    notifyListeners();
    return resp;
  }

  List<Order> orders = [];

  getOrders() async {
    orders.clear();
    String? token = await LoginServices().readToken();
    var response = await Requests.get("$_baseUrl/api/orders",
        headers: {'Authorization': 'Bearer $token'});

    isLoading = true;
    notifyListeners();

    int idUser = 0;
    double finalPrice = 0;
    String companyName = "";
    String userUsername = "";

    List<dynamic> quantities = [];

    var resp;
    if (response.body.isNotEmpty) {
      final List<dynamic> usersResponse =
          json.decode(utf8.decode(response.bodyBytes));
      for (int i = 0; i < usersResponse.length; i++) {
        if (usersResponse[i].containsKey("id")) {
          usersResponse[i].forEach((key, value) {
            String quantitiesArray = "";
            List<Product> productsOrders = [];
            int idProductOrder = 0;
            String nameProductOrder = "";
            String descriptionProductOrder = "";
            double priceProductOrder = 0;
            if (key == "id") {
              idUser = value;
            } else if (key == "finalPrice") {
              finalPrice = value;
            } else if (key == "companyName") {
              companyName = value;
            } else if (key == "userUsername") {
              userUsername = value;
            } else if (key == "quantities") {
              List<dynamic> array1 = response.body.split("\"quantities\":");
              List<dynamic> array2 = array1[1].split(",\"products\"");
              List<dynamic> array3 = array2[0].split("\"");
              for (int i = 0; i < array3.length; i++) {
                quantitiesArray = quantitiesArray + array3[i];
              }
              List<dynamic> array4 = quantitiesArray.split("[");
              List<dynamic> array5 = array4[1].split("]");
              List<dynamic> array6 = array5[0].split(",");
              for (int i = 0; i < array6.length; i++) {
                quantities.add(array6[i]);
              }
            } else if (key == "products") {
              for (int j = 0; j < value.length; j++) {
                value[j].forEach((key, value) {
                  if (key == "id") {
                    idProductOrder = value;
                  } else if (key == "name") {
                    nameProductOrder = value;
                  } else if (key == "description") {
                    descriptionProductOrder = value;
                  } else if (key == "price") {
                    priceProductOrder = value;
                    productsOrders.add(Product(
                        id: idProductOrder,
                        name: nameProductOrder,
                        description: descriptionProductOrder,
                        price: priceProductOrder));
                  }
                });
              }
              Order order = Order(
                  id: idUser,
                  finalPrice: finalPrice,
                  company: companyName,
                  user: userUsername,
                  products: productsOrders,
                  quantities: quantities);

              orders.add(order);
            }
          });
        } else {
          String? error = '';

          error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

          resp = error;
        }
      }

      resp = orders;

      isLoading = false;
      notifyListeners();
      return resp;
    }

    isLoading = false;
    notifyListeners();
    return resp;
  }

  Order? order;

  getOrder(int? idOrder) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.get("$_baseUrl/api/orders/$idOrder",
        headers: {'Authorization': 'Bearer $token'});

    isLoading = true;
    notifyListeners();

    int idUser = 0;
    double finalPrice = 0;
    String companyName = "";
    String userUsername = "";

    var resp;
    if (response.body.isNotEmpty) {
      final Map<String, dynamic> usersResponse =
          json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> quantities = [];

      if (usersResponse.containsKey("id")) {
        usersResponse.forEach((key, value) {
          String quantitiesArray = "";
          List<Product> productsOrders = [];
          int idProductOrder = 0;
          String nameProductOrder = "";
          String descriptionProductOrder = "";
          double priceProductOrder = 0;
          if (key == "id") {
            idUser = value;
          } else if (key == "finalPrice") {
            finalPrice = value;
          } else if (key == "companyName") {
            companyName = value;
          } else if (key == "userUsername") {
            userUsername = value;
          } else if (key == "quantities") {
            List<dynamic> array1 = response.body.split("\"quantities\":");
            List<dynamic> array2 = array1[1].split(",\"products\"");
            List<dynamic> array3 = array2[0].split("\"");
            for (int i = 0; i < array3.length; i++) {
              quantitiesArray = quantitiesArray + array3[i];
            }
            List<dynamic> array4 = quantitiesArray.split("[");
            List<dynamic> array5 = array4[1].split("]");
            List<dynamic> array6 = array5[0].split(",");
            for (int i = 0; i < array6.length; i++) {
              quantities.add(array6[i]);
            }
          } else if (key == "products") {
            for (int k = 0; k < value.length; k++) {
              value[k].forEach((key, value) {
                if (key == "id") {
                  idProductOrder = value;
                } else if (key == "name") {
                  nameProductOrder = value;
                } else if (key == "description") {
                  descriptionProductOrder = value;
                } else if (key == "price") {
                  priceProductOrder = value;
                  productsOrders.add(Product(
                      id: idProductOrder,
                      name: nameProductOrder,
                      description: descriptionProductOrder,
                      price: priceProductOrder));
                }
              });
            }

            order = Order(
                id: idUser,
                finalPrice: finalPrice,
                company: companyName,
                user: userUsername,
                products: productsOrders,
                quantities: quantities);
          }
        });
      } else {
        String? error = '';

        error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

        resp = error;
      }

      resp = order;

      isLoading = false;
      notifyListeners();
      return resp;
    }

    isLoading = false;
    notifyListeners();
    return resp;
  }
}
