import 'package:flutter/material.dart';

class CompanyFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int id = 0;
  String name = '';
  String description = '';

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
