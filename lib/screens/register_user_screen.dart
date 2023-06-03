// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:cool_alert/cool_alert.dart';

import '../providers/register_form_provider.dart';

import '../services/services.dart';
import '../widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterUserScreen extends StatelessWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      const Text('Create account',
                          style: TextStyle(
                              fontSize: 34,
                              color: Color.fromARGB(255, 18, 201, 159))),
                      const SizedBox(height: 10),
                      ChangeNotifierProvider(
                        create: (_) => RegisterFormProvider(),
                        child: _RegisterUserForm(),
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
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'login'),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.indigo.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                child: const Text(
                  'Have an account already?',
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

class _RegisterUserForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    return Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Your email',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelText: 'Email',
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
                  prefixIcon: Icon(Icons.email_rounded,
                      color: Color.fromARGB(255, 18, 201, 159))),
              onChanged: (value) => registerForm.email = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter your email';
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Your username',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 18, 201, 159)),
                  labelText: 'Username',
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
              onChanged: (value) => registerForm.username = value,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Please, enter your username';
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: 'Your password',
                  labelText: 'Password',
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
                  prefixIcon: Icon(Icons.lock_outline_rounded,
                      color: Color.fromARGB(255, 18, 201, 159))),
              onChanged: (value) => registerForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'Please, enter a valid password';
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
                  final registerService =
                      Provider.of<RegisterServices>(context, listen: false);
                  if (registerForm.isValidForm()) {
                    final String? errorMessage =
                        await registerService.postRegister(registerForm.email,
                            registerForm.username, registerForm.password);

                    if (errorMessage == "") {
                      RegisterServices().logout();
                      Navigator.pushReplacementNamed(context, 'login');
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
                child: const Center(child: Text('Register')),
              ),
            ),
          ],
        ));
  }
}
