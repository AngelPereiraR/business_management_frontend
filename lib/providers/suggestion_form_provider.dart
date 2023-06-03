// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class SuggestionFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String commentary = '';

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
