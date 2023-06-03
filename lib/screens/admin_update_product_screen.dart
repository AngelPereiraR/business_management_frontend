// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:cool_alert/cool_alert.dart';

import '../providers/product_form_provider.dart';

import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';
import 'package:provider/provider.dart';

int? idCompanyProductEditAdmin;
int? idCategoryProductEditAdmin;
int? idProductEditAdmin;
String? nameProductEditAdmin;
String? descriptionProductEditAdmin;
double? priceProductEditAdmin;
String? usernameUpdateProductAdmin;

class AdminUpdateProductScreen extends StatefulWidget {
  final int? idCompany;
  final String? username;
  final int? idCategory;
  final int? idProduct;
  final String? nameProduct;
  final String? descriptionProduct;
  final double? priceProduct;
  const AdminUpdateProductScreen(
      {Key? key,
      this.idCompany,
      this.idCategory,
      this.idProduct,
      this.nameProduct,
      this.descriptionProduct,
      this.priceProduct,
      this.username})
      : super(key: key);

  @override
  State<AdminUpdateProductScreen> createState() =>
      _AdminUpdateProductScreenState();
}

class _AdminUpdateProductScreenState extends State<AdminUpdateProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    idCompanyProductEditAdmin = widget.idCompany;
    idCategoryProductEditAdmin = widget.idCategory;
    idProductEditAdmin = widget.idProduct;
    nameProductEditAdmin = widget.nameProduct;
    descriptionProductEditAdmin = widget.descriptionProduct;
    priceProductEditAdmin = widget.priceProduct;
    usernameUpdateProductAdmin = widget.username;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: AuthBackground(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              const SizedBox(height: 180),
              CardContainer(
                  child: SizedBox(
                width: 300,
                child: DecoratedBox(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                          // ignore: prefer_const_literals_to_create_immutables
                          boxShadow: [
                        const BoxShadow(
                          color: Colors.white,
                          blurRadius: 5,
                          offset: Offset(0, 0),
                        )
                      ]),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text('Update product',
                            style: TextStyle(
                                fontSize: 34,
                                color: Color.fromARGB(255, 18, 201, 159))),
                        const SizedBox(height: 10),
                        ChangeNotifierProvider(
                          create: (_) => ProductFormProvider(),
                          child: _InsertProductForm(),
                        )
                      ],
                    ),
                  ),
                ),
              )),
              const SizedBox(
                height: 5,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminProductsScreen(
                                  idCompany: idCompanyProductEditAdmin,
                                  idCategory: idCategoryProductEditAdmin,
                                  username: usernameUpdateProductAdmin,
                                )));
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Text(
                    'Return',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 18, 201, 159),
                    ),
                  ))
            ],
          )))),
    );
  }
}

class _InsertProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Form(
        key: productForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              initialValue: nameProductEditAdmin,
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Product name',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelText: 'Name',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 18, 201, 159))),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 18, 201, 159))),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 18, 201, 159)),
                  ),
                  prefixIcon: Icon(Icons.account_circle,
                      color: Color.fromARGB(255, 18, 201, 159))),
              onChanged: (value) => nameProductEditAdmin = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the product name';
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: descriptionProductEditAdmin,
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Product description',
                  labelText: 'Description',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 18, 201, 159))),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 18, 201, 159))),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 18, 201, 159)),
                  ),
                  prefixIcon: Icon(Icons.description,
                      color: Color.fromARGB(255, 18, 201, 159))),
              onChanged: (value) => descriptionProductEditAdmin = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the product description';
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: priceProductEditAdmin.toString(),
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Product price',
                  labelText: 'Price',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 18, 201, 159))),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 18, 201, 159))),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 18, 201, 159)),
                  ),
                  prefixIcon: Icon(Icons.price_check,
                      color: Color.fromARGB(255, 18, 201, 159))),
              onChanged: (value) => priceProductEditAdmin = double.parse(value),
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the product price';
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 18, 201, 159)),
                  fixedSize: MaterialStateProperty.all(
                      const Size(double.infinity, 30)),
                ),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final insertProductService =
                      Provider.of<UpdateServices>(context, listen: false);
                  if (productForm.isValidForm()) {
                    final String? errorMessage =
                        await insertProductService.updateProduct(
                            idCompanyProductEditAdmin,
                            idCategoryProductEditAdmin,
                            idProductEditAdmin,
                            nameProductEditAdmin,
                            descriptionProductEditAdmin,
                            priceProductEditAdmin);

                    if (errorMessage == "OK") {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminProductsScreen(
                                    idCompany: idCompanyProductEditAdmin,
                                    idCategory: idCategoryProductEditAdmin,
                                    username: usernameUpdateProductAdmin,
                                  )));
                    } else {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        text: errorMessage,
                        borderRadius: 30,
                        loopAnimation: true,
                        confirmBtnColor: Colors.red,
                      );
                    }
                  }
                },
                child: const Center(child: Text('Update')),
              ),
            ),
          ],
        ));
  }
}
