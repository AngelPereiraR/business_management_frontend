// ignore_for_file: unused_element, camel_case_types

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';
import '../providers/category_form_provider.dart';

import '../screens/screens.dart';
import '../models/models.dart';
import '../services/services.dart';

var _counter = 0;
String? usernameCompanyScreen;
Company? company;

class CompanyScreen extends StatefulWidget {
  final String? username;
  const CompanyScreen({Key? key, this.username}) : super(key: key);

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

final formKey = GlobalKey<FormState>();

class _CompanyScreenState extends State<CompanyScreen> {
  final getServices = GetServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usernameCompanyScreen = widget.username;
    getServices.isLoading = false;
    return getServices.isLoading
        ? const Center(
            child: SpinKitWave(color: Color.fromRGBO(0, 153, 153, 1), size: 50))
        : WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
                appBar: _appbar(context),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const SizedBox(height: 5),
                          // const ProductsSearchUser(),
                          listProducts2(
                            username: widget.username,
                            formKey: formKey,
                          )
                        ],
                      )
                    ],
                  ),
                )),
          );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        color: Colors.black,
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
        },
        icon: const Icon(Icons.logout_rounded),
      ),
      actions: [
        Tooltip(
          message: "Suggestions",
          child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompanySuggestionsScreen(
                              id: company?.id,
                              username: widget.username,
                            )));
              },
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder())),
              child: const Icon(Icons.comment_rounded, color: Colors.black)),
        )
      ],
    );
  }
}

class listProducts2 extends StatefulWidget {
  final String? username;
  final GlobalKey<FormState> formKey;
  const listProducts2({super.key, this.username, required this.formKey});

  @override
  State<listProducts2> createState() => _listProductsState();
}

class _listProductsState extends State<listProducts2> {
  List<Product> products = [];
  List<Category> categories = [];
  List<ProductItem> productItems = [];
  final getServices = GetServices();
  final deleteServices = DeleteServices();
  int minQuantity = 1;
  Future refresh() async {
    await getServices.getCompanyFromUser(widget.username);
    await getServices.getCompanyFromUser(widget.username);
    setState(() {
      company = getServices.company;
    });
    setState(() => products.clear());

    await getServices.getCategories(company?.id);
    await getServices.getProductsFromCompany(company?.id);
    setState(() {
      categories = getServices.categories;
      products = getServices.products3;
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
      await getServices.getProductsFromCategory(value);
      setState(() {
        products = getServices.products2;
      });
    }

    return Form(
      key: widget.formKey,
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
              const SizedBox(width: 15),
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
          const SizedBox(height: 15),
          Row(
            children: [
              const SizedBox(width: 15),
              Tooltip(
                message: "Insert category",
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompanyInsertCategoryScreen(
                                    id: company?.id,
                                    username: widget.username,
                                  )));
                    },
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.indigo.withOpacity(0.1)),
                        shape:
                            MaterialStateProperty.all(const StadiumBorder())),
                    child: const Icon(Icons.add, color: Colors.black)),
              ),
              Tooltip(
                message: 'Delete category',
                child: TextButton(
                    onPressed: () async {
                      await CoolAlert.show(
                        context: context,
                        type: CoolAlertType.warning,
                        title: 'Are you sure?',
                        text: "Are you sure you want to delete this category?",
                        showCancelBtn: true,
                        confirmBtnColor: Colors.red,
                        confirmBtnText: 'Delete',
                        onConfirmBtnTap: () {
                          deleteServices.deleteCategory(categoryForm.id);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoadingCompanyScreen(
                                      username: widget.username)));
                        },
                        onCancelBtnTap: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.indigo.withOpacity(0.1)),
                        shape:
                            MaterialStateProperty.all(const StadiumBorder())),
                    child: const Icon(Icons.delete, color: Colors.black)),
              ),
              Tooltip(
                message: 'Edit category',
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompanyUpdateCategoryScreen(
                                    username: widget.username,
                                    idCompany: company?.id,
                                    idCategory: categoryForm.id,
                                    name: categoryForm.name,
                                    description: categoryForm.description,
                                  )));
                    },
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.indigo.withOpacity(0.1)),
                        shape:
                            MaterialStateProperty.all(const StadiumBorder())),
                    child: const Icon(Icons.manage_accounts_rounded,
                        color: Colors.black)),
              ),
              const SizedBox(width: 140),
              Tooltip(
                message: "Insert product",
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompanyInsertProductScreen(
                                    idCompany: company?.id,
                                    idCategory: categoryForm.id,
                                    username: widget.username,
                                  )));
                    },
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.indigo.withOpacity(0.1)),
                        shape:
                            MaterialStateProperty.all(const StadiumBorder())),
                    child: const Icon(Icons.add_shopping_cart_rounded,
                        color: Colors.black)),
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
                                    'Price: ${products[index].price}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    maxLines: 2,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Tooltip(
                                    message: 'Edit product',
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CompanyUpdateProductScreen(
                                                          username:
                                                              usernameCompanyScreen,
                                                          idCompany:
                                                              company?.id,
                                                          idCategory:
                                                              categoryForm.id,
                                                          idProduct:
                                                              products[index]
                                                                  .id,
                                                          nameProduct:
                                                              products[index]
                                                                  .name,
                                                          descriptionProduct:
                                                              products[index]
                                                                  .description,
                                                          priceProduct:
                                                              products[index]
                                                                  .price)));
                                        },
                                        style: ButtonStyle(
                                            overlayColor:
                                                MaterialStateProperty.all(Colors
                                                    .indigo
                                                    .withOpacity(0.1)),
                                            shape: MaterialStateProperty.all(
                                                const StadiumBorder())),
                                        child: const Icon(
                                            Icons.manage_accounts_rounded,
                                            color: Colors.black)),
                                  ),
                                  const SizedBox(width: 35),
                                  Tooltip(
                                    message: 'Delete product',
                                    child: TextButton(
                                        onPressed: () async {
                                          await CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.warning,
                                            title: 'Are you sure?',
                                            text:
                                                "Are you sure you want to delete this product?",
                                            showCancelBtn: true,
                                            confirmBtnColor: Colors.red,
                                            confirmBtnText: 'Delete',
                                            onConfirmBtnTap: () {
                                              deleteServices.deleteProduct(
                                                  products[index].id);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoadingCompanyScreen(
                                                              username: widget
                                                                  .username)));
                                            },
                                            onCancelBtnTap: () {
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty
                                                .resolveWith((states) =>
                                                    const EdgeInsets.all(8)),
                                            overlayColor:
                                                MaterialStateProperty.all(Colors
                                                    .indigo
                                                    .withOpacity(0.1)),
                                            shape: MaterialStateProperty.all(
                                                const StadiumBorder())),
                                        child: const Icon(Icons.delete,
                                            color: Colors.black)),
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
                      mainAxisExtent: 150,
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
