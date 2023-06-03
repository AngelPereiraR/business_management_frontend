// ignore_for_file: unused_element, camel_case_types

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../screens/screens.dart';

import 'package:provider/provider.dart';
import '../providers/category_form_provider.dart';

import '../models/models.dart';
import '../services/services.dart';

var _counter = 0;
int? idProductScreen;
String? usernameProductScreen;
String? companyUserProductScreen;
List<ProductCart> productCartList = <ProductCart>[];

class ProductScreen extends StatefulWidget {
  final String? companyUser;
  final int? id;
  final String? username;
  const ProductScreen({Key? key, this.id, this.username, this.companyUser})
      : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];
  List<Category> categories = [];
  final productsService = GetServices();

  Future refresh() async {
    setState(() => products.clear());
    await productsService.getProductsFromCompany(widget.id);

    setState(() {
      products = productsService.products3;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    idProductScreen = widget.id;
    usernameProductScreen = widget.username;
    productsService.isLoading = false;
    companyUserProductScreen = widget.companyUser;
    return productsService.isLoading
        ? const Center(
            child: SpinKitWave(color: Color.fromRGBO(0, 153, 153, 1), size: 50))
        : Scaffold(
            appBar: _appbar(context),
            body: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(height: 5),
                      // const ProductsSearchUser(),
                      listProducts1()
                    ],
                  )
                ],
              ),
            ));
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        color: Colors.black,
        onPressed: () {
          productCartList.clear();
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      UserCompaniesScreen(username: widget.username)));
        },
        icon: const Icon(Icons.keyboard_return_rounded),
      ),
      actions: [
        IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserSuggestionsScreen(
                        username: widget.username,
                        id: widget.id,
                        companyUser: widget.companyUser)));
          },
          icon: const Icon(Icons.chat_rounded),
        ),
        if (productCartList.isNotEmpty)
          IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductCartScreen(
                            username: widget.username,
                            id: widget.id,
                            productCartList: productCartList,
                            companyUser: widget.companyUser,
                          )));
            },
            icon: const Icon(Icons.shopping_cart_rounded),
          ),
      ],
    );
  }
}

class listProducts1 extends StatefulWidget {
  const listProducts1({super.key});

  @override
  State<listProducts1> createState() => _listProductsState();
}

class _listProductsState extends State<listProducts1> {
  List<Product> products = [];
  List<Category> categories = [];
  List<ProductItem> productItems = [];
  final productsCompanyService = GetServices();
  final categoryService = GetServices();
  final productsService = GetServices();
  int minQuantity = 1;
  Future refresh() async {
    setState(() => products.clear());
    await categoryService.getCategories(idProductScreen);
    await productsService.getProductsFromCompany(idProductScreen);
    setState(() {
      categories = categoryService.categories;
      products = productsService.products3;
      productItems =
          products.map((product) => ProductItem(selectedQuantity: 1)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final categoryForm = Provider.of<CategoryFormProvider>(context);
    refreshProducts(int value) async {
      products.clear();
      await productsCompanyService.getProductsFromCategory(value);
      setState(() {
        products = productsCompanyService.products2;
      });
    }

    return Form(
      key: GlobalKey<FormState>(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsetsDirectional.only(
                  start: 40,
                  top: 20,
                ),
                height: 50,
                width: 200,
                child: DropdownButtonFormField(
                  items: categories.map((e) {
                    /// Ahora creamos "e" y contiene cada uno de los items de la lista.
                    categoryForm.id = e.id;
                    categoryForm.name = e.name;
                    categoryForm.description = e.description;

                    return DropdownMenuItem(
                      onTap: (() {
                        categoryForm.id = e.id;
                        categoryForm.name = e.name;
                        categoryForm.description = e.description;
                      }),
                      value: e.id,
                      child: Text(
                        e.name.toString(),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 18, 201, 159)),
                        maxLines: 2,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    categoryForm.id = value!;
                  },
                  validator: (value) {
                    return (value != null && value != 0)
                        ? null
                        : 'Default category to submit: ${categoryForm.name}';
                  },
                  autovalidateMode: AutovalidateMode.always,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 18, 201, 159)),
                    minimumSize: MaterialStateProperty.all(const Size(50, 50))),
                onPressed: () {
                  setState(() {
                    refreshProducts(categoryForm.id);
                  });
                },
                child: const Text('Submit', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
          Visibility(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 600,
                width: 400,
                child: GridView.builder(
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: 10,
                          height: 330,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              // ignore: prefer_const_literals_to_create_immutables
                              boxShadow: [
                                const BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 5,
                                  offset: Offset(0, 0),
                                )
                              ]),
                          child: Column(
                            children: [
                              Row(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Tooltip(
                                    message: products[index].name,
                                    child: Text(
                                      products[index].name.length <= 15
                                          ? products[index].name
                                          : "${products[index].name.substring(0, 15)}...",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Tooltip(
                                    message: products[index].description,
                                    child: Text(
                                      products[index].description.length <= 15
                                          ? products[index].description
                                          : "${products[index].description.substring(0, 15)}...",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 0.5,
                                color: Colors.black54,
                              ),
                              Row(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    'Price: ${products[index].price} €',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    maxLines: 2,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        int selectedQuantityProduct = 0;
                                        for (int i = 0;
                                            i < productCartList.length;
                                            i++) {
                                          if (productCartList[i].product.id ==
                                              products[index].id) {
                                            selectedQuantityProduct =
                                                productCartList[i].quantity;

                                            productCartList.removeAt(i);
                                          }
                                        }

                                        productCartList.add(ProductCart(
                                            products[index],
                                            productItems[index]
                                                    .selectedQuantity +
                                                selectedQuantityProduct));
                                        CoolAlert.show(
                                          barrierDismissible: false,
                                          context: context,
                                          type: CoolAlertType.success,
                                          text:
                                              "${productItems[index].selectedQuantity} ${products[index].name} added to cart",
                                          borderRadius: 30,
                                          //loopAnimation: true,
                                          onConfirmBtnTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoadingUserProductScreen(
                                                          username:
                                                              usernameProductScreen,
                                                          id: idProductScreen,
                                                          companyUser:
                                                              companyUserProductScreen)),
                                            );
                                          },
                                          confirmBtnColor: Colors.blue,
                                        );
                                      },
                                      child: const Icon(
                                        Icons.add_shopping_cart_rounded,
                                        size: 35,
                                      )),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (productItems[index]
                                                .selectedQuantity >
                                            minQuantity) {
                                          productItems[index]
                                              .selectedQuantity--;
                                        }
                                      });
                                    },
                                    child: const Icon(
                                      Icons.remove,
                                      size: 35,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    productItems[index]
                                        .selectedQuantity
                                        .toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        productItems[index].selectedQuantity++;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      size: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 135,
                      mainAxisSpacing: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
