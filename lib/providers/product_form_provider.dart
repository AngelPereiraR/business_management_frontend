// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';
  double price = 0.0;

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
