// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, must_be_immutable, library_private_types_in_public_api

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:gestion_empresas/screens/screens.dart';

import '../providers/login_form_provider.dart';
import '../services/services.dart';

import '../widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AuthBackground(
            child: SingleChildScrollView(
                child: Column(
          children: [
            const SizedBox(height: 250),
            CardContainer(
                child: Column(
              children: [
                SizedBox(
                  width: 300,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
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
                            const Text('Login',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 18, 201, 159),
                                    fontSize: 38)),
                            const SizedBox(height: 10),
                            ChangeNotifierProvider(
                              create: (_) => LoginFormProvider(),
                              child: _LoginForm(),
                              // child: StaggerDemo1(),
                            )
                          ],
                        ),
                      )),
                )
              ],
            )),
            const SizedBox(
              height: 50,
            ),
            TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'registerUser'),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.indigo.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                child: const Text(
                  'Create new account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 18, 201, 159),
                  ),
                ))
          ],
        ))));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginService = Provider.of<LoginServices>(context);
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelText: 'Username',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  prefixIcon: Icon(Icons.account_circle,
                      color: Color.fromARGB(255, 18, 201, 159)),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 18, 201, 159))),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 18, 201, 159)),
                  ),
                ),
                onChanged: (value) => loginForm.username = value,
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Please, enter your username';
                }),
            const SizedBox(height: 20),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: 'User password',
                  labelText: 'Password',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 18, 201, 159)),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 18, 201, 159)),
                  ),
                  prefixIcon: Icon(Icons.lock_outline_rounded,
                      color: Color.fromARGB(255, 18, 201, 159)),
                  iconColor: Color.fromRGBO(0, 153, 153, 1)),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter your password';
              },
            ),
            const SizedBox(height: 20),
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
                  if (loginForm.isValidForm()) {
                    final String? errorMessage = await loginService.postLogin(
                        loginForm.username, loginForm.password);
                    if (errorMessage == 'ROLE_ADMIN') {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminCompaniesScreen(
                                  username: loginForm.username)));
                    } else if (errorMessage == 'ROLE_COMPANY') {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CompanyScreen(username: loginForm.username)));
                    } else if (errorMessage == 'ROLE_USER') {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserCompaniesScreen(
                                  username: loginForm.username)));
                    } else {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        text: errorMessage,
                        borderRadius: 30,
                        //loopAnimation: true,
                        confirmBtnColor: Colors.red,
                      );
                    }
                  }
                },
                child: const Center(child: Text('Login')),
              ),
            ),
          ],
        ));
  }
}
