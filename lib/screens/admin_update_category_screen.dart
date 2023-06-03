// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:cool_alert/cool_alert.dart';
import 'package:gestion_empresas/screens/screens.dart';

import '../providers/category_form_provider.dart';

import '../services/services.dart';
import '../widgets/widgets.dart';
import 'package:provider/provider.dart';

int? idCompanyEditAdmin;
int? idCategoryEditAdmin;
String? nameCategoryAdmin;
String? descriptionCategoryAdmin;
String? usernameUpdateCategoryAdmin;

class AdminUpdateCategoryScreen extends StatefulWidget {
  final int? idCompany;
  final String? username;
  final int? idCategory;
  final String? name;
  final String? description;
  const AdminUpdateCategoryScreen(
      {Key? key,
      this.idCompany,
      this.idCategory,
      this.name,
      this.description,
      this.username})
      : super(key: key);

  @override
  State<AdminUpdateCategoryScreen> createState() =>
      _AdminUpdateCategoryScreenState();
}

class _AdminUpdateCategoryScreenState extends State<AdminUpdateCategoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    idCompanyEditAdmin = widget.idCompany;
    idCategoryEditAdmin = widget.idCategory;
    nameCategoryAdmin = widget.name;
    descriptionCategoryAdmin = widget.description;
    usernameUpdateCategoryAdmin = widget.username;
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
                        const Text('Update category',
                            style: TextStyle(
                                fontSize: 34,
                                color: Color.fromARGB(255, 18, 201, 159))),
                        const SizedBox(height: 10),
                        ChangeNotifierProvider(
                          create: (_) => CategoryFormProvider(),
                          child: _UpdateCategoryForm(),
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
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminCategoriesScreen(
                                id: widget.idCompany,
                                username: usernameUpdateCategoryAdmin,
                              ))),
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

class _UpdateCategoryForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryForm = Provider.of<CategoryFormProvider>(context);
    return Form(
        key: categoryForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              initialValue: nameCategoryAdmin,
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Category name',
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
              onChanged: (value) => nameCategoryAdmin = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the category name';
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: descriptionCategoryAdmin,
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Category description',
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
              onChanged: (value) => descriptionCategoryAdmin = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the category description';
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
                  final insertCategoryService =
                      Provider.of<UpdateServices>(context, listen: false);
                  if (categoryForm.isValidForm()) {
                    final String? errorMessage =
                        await insertCategoryService.updateCategory(
                            idCompanyEditAdmin,
                            idCategoryEditAdmin,
                            nameCategoryAdmin,
                            descriptionCategoryAdmin);

                    if (errorMessage == "OK") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminCategoriesScreen(
                                    id: idCompanyEditAdmin,
                                    username: usernameUpdateCategoryAdmin,
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
