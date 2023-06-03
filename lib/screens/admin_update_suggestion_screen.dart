// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:cool_alert/cool_alert.dart';

import '../providers/product_form_provider.dart';

import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';
import 'package:provider/provider.dart';

int? idCompanyUpdateSuggestionAdmin;
int? idSuggestionUpdateSuggestionAdmin;
String? commentaryUpdateSuggestionAdmin;
String? stateUpdateSuggestionAdmin;
String? usernameUpdateSuggestionAdmin;

class AdminUpdateSuggestionScreen extends StatefulWidget {
  final int? idCompany;
  final String? username;
  final int? idSuggestion;
  final String? commentary;
  final String? state;
  const AdminUpdateSuggestionScreen(
      {Key? key,
      this.idCompany,
      this.idSuggestion,
      this.commentary,
      this.state,
      this.username})
      : super(key: key);

  @override
  State<AdminUpdateSuggestionScreen> createState() =>
      _AdminUpdateSuggestionScreenState();
}

class _AdminUpdateSuggestionScreenState
    extends State<AdminUpdateSuggestionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    idCompanyUpdateSuggestionAdmin = widget.idCompany;
    idSuggestionUpdateSuggestionAdmin = widget.idSuggestion;
    commentaryUpdateSuggestionAdmin = widget.commentary;
    stateUpdateSuggestionAdmin = widget.state;
    usernameUpdateSuggestionAdmin = widget.username;

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
                        const Text('Update suggestion',
                            style: TextStyle(
                                fontSize: 34,
                                color: Color.fromARGB(255, 18, 201, 159))),
                        const SizedBox(height: 10),
                        ChangeNotifierProvider(
                          create: (_) => ProductFormProvider(),
                          child: _UpdateSuggestionForm(),
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
                            builder: (context) => AdminSuggestionsScreen(
                                  id: idCompanyUpdateSuggestionAdmin,
                                  username: usernameUpdateSuggestionAdmin,
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

class _UpdateSuggestionForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Form(
        key: productForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              initialValue: commentaryUpdateSuggestionAdmin,
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Commentary',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelText: 'Commentary',
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
              onChanged: (value) => commentaryUpdateSuggestionAdmin = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter the commentary';
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
                        await insertProductService.updateSuggestion(
                            idCompanyUpdateSuggestionAdmin,
                            idSuggestionUpdateSuggestionAdmin,
                            commentaryUpdateSuggestionAdmin,
                            stateUpdateSuggestionAdmin,
                            usernameUpdateSuggestionAdmin);

                    if (errorMessage == "OK") {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminSuggestionsScreen(
                                    id: idCompanyUpdateSuggestionAdmin,
                                    username: usernameUpdateSuggestionAdmin,
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
