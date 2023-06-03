// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

String? usernameUserCompanies;

class UserCompaniesScreen extends StatefulWidget {
  final String? username;
  const UserCompaniesScreen({
    Key? key,
    this.username,
  }) : super(key: key);

  @override
  State<UserCompaniesScreen> createState() => _UserCompaniesScreenState();
}

class _UserCompaniesScreenState extends State<UserCompaniesScreen> {
  List<Company> companies = [];
  final getServices = GetServices();
  Future refresh() async {
    setState(() => companies.clear());
    await getServices.getCompanies();
    await getServices.getCompanies();
    setState(() {
      companies = getServices.companies;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    usernameUserCompanies = widget.username;
    if (getServices.isLoading) return const LoadingScreen();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 123, 255),
          leading: const Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.apartment_rounded),
              SizedBox(width: 10),
              Text('Companies  '),
            ],
          ),
          leadingWidth: 150,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: const ExampleExpandableFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: RefreshIndicator(
            onRefresh: () async {
              refresh();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserCompaniesScreen(username: widget.username)));
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return MySlidable7(
                  id: companies[index].id,
                  index: index,
                  tit: companies[index].name,
                  desc: companies[index].description,
                  numberCategories: companies[index].categories.length,
                  numberProducts: companies[index].products.length,
                );
              },
              itemCount: companies.length,
            )),
      ),
    );
  }
}

class MySlidable7 extends StatelessWidget {
  final String tit;
  final String desc;
  final int id;
  final int index;
  final int numberCategories;
  final int numberProducts;
  const MySlidable7({
    Key? key,
    required this.tit,
    required this.desc,
    required this.id,
    required this.index,
    required this.numberCategories,
    required this.numberProducts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(

        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () {}),
          dragDismissible: false,

          // All actions are defined in the children parameter.
          children: [
            Visibility(
              visible: true,
              child: SlidableAction(
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductScreen(
                              id: id,
                              username: usernameUserCompanies,
                              companyUser: tit)));
                },
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.category_rounded,
                label: 'See Categories and Products',
              ),
            ),
          ],
        ),

        // The end action pane is the one at the right or the bottom side.

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: ListTile(
          title: Text(tit),
          subtitle: Text(desc),
        ));
  }

  static void goview(String route, BuildContext context) {
    Navigator.pushNamed(context, route);
  }
}
