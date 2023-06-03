import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';
import '../providers/company_form_provider.dart';
import '../providers/category_form_provider.dart';

import 'router/app_routes.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => LoginServices()),
      ChangeNotifierProvider(create: (_) => RegisterServices()),
      ChangeNotifierProvider(create: (_) => DeleteServices()),
      ChangeNotifierProvider(create: (_) => GetServices()),
      ChangeNotifierProvider(create: (_) => InsertServices()),
      ChangeNotifierProvider(create: (_) => UpdateServices()),
      ChangeNotifierProvider(create: (_) => CompanyFormProvider()),
      ChangeNotifierProvider(create: (_) => CategoryFormProvider()),
    ], child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Business Management',
      initialRoute: AppRoutes.initialRoute,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      routes: AppRoutes.getAppRoutes(),
      theme: ThemeData.light().copyWith(
          //Color primario
          scaffoldBackgroundColor: Colors.grey[300],
          primaryColor: const Color.fromARGB(197, 17, 193, 134),
          //appbar thme
          appBarTheme: const AppBarTheme(
              color: Color.fromARGB(197, 17, 193, 134), elevation: 0)),
    );
  }
}
