// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:cool_alert/cool_alert.dart';

import '../providers/product_form_provider.dart';

import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';
import 'package:provider/provider.dart';

int? idCompanyProductCompany;
int? idCategoryProductCompany;
String? usernameProductCompany;

class CompanyInsertProductScreen extends StatefulWidget {
  final String? username;
  final int? idCompany;
  final int? idCategory;
  const CompanyInsertProductScreen(
      {Key? key, this.idCompany, this.idCategory, this.username})
      : super(key: key);

  @override
  State<CompanyInsertProductScreen> createState() =>
      _CompanyInsertProductScreenState();
}

class _CompanyInsertProductScreenState
    extends State<CompanyInsertProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    idCompanyProductCompany = widget.idCompany;
    idCategoryProductCompany = widget.idCategory;
    usernameProductCompany = widget.username;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: CompanyAuthBackground(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              const SizedBox(height: 180),
              CompanyCardContainer(
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
                        const Text('Create product',
                            style: TextStyle(
                                fontSize: 34,
                                color: Color.fromARGB(255, 255, 97, 0))),
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
                            builder: (context) =>
                                CompanyScreen(username: widget.username)));
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
                      color: Color.fromARGB(255, 255, 97, 0),
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
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Product name',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 255, 97, 0)),
                  labelStyle: TextStyle(color: Color.fromARGB(255, 255, 97, 0)),
                  labelText: 'Name',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 255, 97, 0))),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 255, 97, 0))),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 255, 97, 0)),
                  ),
                  prefixIcon: Icon(Icons.account_circle,
                      color: Color.fromARGB(255, 255, 97, 0))),
              onChanged: (value) => productForm.name = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the product name';
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Product description',
                  labelText: 'Description',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 255, 97, 0)),
                  labelStyle: TextStyle(color: Color.fromARGB(255, 255, 97, 0)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 255, 97, 0))),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 255, 97, 0))),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 255, 97, 0)),
                  ),
                  prefixIcon: Icon(Icons.description,
                      color: Color.fromARGB(255, 255, 97, 0))),
              onChanged: (value) => productForm.description = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the product description';
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Product price',
                  labelText: 'Price',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 255, 97, 0)),
                  labelStyle: TextStyle(color: Color.fromARGB(255, 255, 97, 0)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 255, 97, 0))),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 255, 97, 0))),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 255, 97, 0)),
                  ),
                  prefixIcon: Icon(Icons.price_check,
                      color: Color.fromARGB(255, 255, 97, 0))),
              onChanged: (value) => productForm.price = double.parse(value),
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
                      const Color.fromARGB(255, 255, 97, 0)),
                  fixedSize: MaterialStateProperty.all(
                      const Size(double.infinity, 30)),
                ),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final insertProductService =
                      Provider.of<InsertServices>(context, listen: false);
                  if (productForm.isValidForm()) {
                    final String? errorMessage =
                        await insertProductService.insertProduct(
                            idCompanyProductCompany,
                            idCategoryProductCompany,
                            productForm.name,
                            productForm.description,
                            productForm.price);

                    if (errorMessage == "OK") {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompanyScreen(
                                  username: usernameProductCompany)));
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
                child: const Center(child: Text('Create')),
              ),
            ),
          ],
        ));
  }
}
