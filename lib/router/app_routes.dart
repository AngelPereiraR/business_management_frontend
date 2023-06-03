import 'package:flutter/material.dart';

import '../models/models.dart';
import '../screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'Login';

  static final menuOptions = <MenuOption>[
    MenuOption(
        route: 'login',
        name: 'Login Screen',
        screen: const LoginScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'registerUser',
        name: 'Register User Screen',
        screen: const RegisterUserScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'registerCompany',
        name: 'Register Company Screen',
        screen: const RegisterCompanyScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'load',
        name: 'Loading Screen',
        screen: const LoadingScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'productscreen',
        name: 'Product Screen',
        screen: const ProductScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'adminCategories',
        name: 'Admin Categories Screen',
        screen: const AdminCategoriesScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'adminCompanies',
        name: 'Admin Companies Screen',
        screen: const AdminCompaniesScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'userCompanies',
        name: 'User Companies Screen',
        screen: const UserCompaniesScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'adminProducts',
        name: 'Admin Products Screen',
        screen: const AdminProductsScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'insertCompany',
        name: 'Admin Insert Company Screen',
        screen: const AdminInsertCompanyScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'adminInsertCategory',
        name: 'Admin Insert Category Screen',
        screen: const AdminInsertCategoryScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'adminUpdateCategory',
        name: 'Admin Update Category Screen',
        screen: const AdminUpdateCategoryScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'adminInsertProduct',
        name: 'Admin Insert Product Screen',
        screen: const AdminInsertProductScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'adminUpdateProduct',
        name: 'Admin Update Product Screen',
        screen: const AdminUpdateProductScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'adminUsers',
        name: 'Admin Users Screen',
        screen: const AdminUsersScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'adminUpdateompany',
        name: 'Admin Update Company Screen',
        screen: const AdminUpdateCompanyScreen(),
        icon: Icons.account_balance_outlined),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    for (final options in menuOptions) {
      appRoutes
          .addAll({options.route: (BuildContext context) => options.screen});
    }

    return appRoutes;
  }

  //static Map<String, Widget Function(BuildContext)> routes = {
  // 'home': (BuildContext context) => const HomeScreen(),
  //'listview1': (BuildContext context) => const Listview1Screen(),
  //'listview2': (BuildContext context) => const Listview2Screen(),
  //'alert': (BuildContext context) => const AlertScreen(),
  //'card': (BuildContext context) => const CardScreen(),
  // };

  static Route<dynamic> onGenerateRoute(settings) {
    return MaterialPageRoute(builder: (context) => const LoginScreen());
  }
}
