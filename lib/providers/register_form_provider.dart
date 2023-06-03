// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class RegisterFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String username = '';
  String password = '';

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
