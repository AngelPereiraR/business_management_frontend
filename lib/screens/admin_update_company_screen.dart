// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:cool_alert/cool_alert.dart';

import '../providers/company_form_provider.dart';

import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';
import 'package:provider/provider.dart';

int? idCompanyAdmin;
String? nameCompanyAdmin;
String? descriptionCompanyAdmin;
String? usernameUpdateCompanyAdmin;

class AdminUpdateCompanyScreen extends StatefulWidget {
  final int? id;
  final String? username;
  final String? name;
  final String? description;
  const AdminUpdateCompanyScreen(
      {Key? key, this.id, this.name, this.description, this.username})
      : super(key: key);

  @override
  State<AdminUpdateCompanyScreen> createState() =>
      _AdminUpdateCompanyScreenState();
}

class _AdminUpdateCompanyScreenState extends State<AdminUpdateCompanyScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    idCompanyAdmin = widget.id;
    nameCompanyAdmin = widget.name;
    descriptionCompanyAdmin = widget.description;
    usernameUpdateCompanyAdmin = widget.username;
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
                        const Text('Update company',
                            style: TextStyle(
                                fontSize: 34,
                                color: Color.fromARGB(255, 18, 201, 159))),
                        const SizedBox(height: 10),
                        ChangeNotifierProvider(
                          create: (_) => CompanyFormProvider(),
                          child: _UpdateCompanyForm(),
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
                          builder: (context) => AdminCompaniesScreen(
                              username: usernameUpdateCompanyAdmin))),
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

class _UpdateCompanyForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final companyForm = Provider.of<CompanyFormProvider>(context);
    return Form(
        key: companyForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              initialValue: nameCompanyAdmin,
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Company name',
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
              onChanged: (value) => nameCompanyAdmin = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the company name';
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: descriptionCompanyAdmin,
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Company description',
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
              onChanged: (value) => descriptionCompanyAdmin = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the company description';
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
                  final companyService =
                      Provider.of<UpdateServices>(context, listen: false);
                  if (companyForm.isValidForm()) {
                    final String? errorMessage =
                        await companyService.updateCompany(idCompanyAdmin,
                            nameCompanyAdmin, descriptionCompanyAdmin);

                    if (errorMessage == "OK") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminCompaniesScreen(
                                  username: usernameUpdateCompanyAdmin)));
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
