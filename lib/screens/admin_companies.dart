// ignore_for_file: non_constant_identifier_names

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

String? usernameCompaniesAdmin;

class AdminCompaniesScreen extends StatefulWidget {
  final String? username;
  const AdminCompaniesScreen({
    Key? key,
    this.username,
  }) : super(key: key);

  @override
  State<AdminCompaniesScreen> createState() => _AdminCompaniesScreenState();
}

class _AdminCompaniesScreenState extends State<AdminCompaniesScreen> {
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
    usernameCompaniesAdmin = widget.username;
    if (getServices.isLoading) return const LoadingScreen();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.apartment_rounded),
              SizedBox(width: 10),
              Text('Companies  '),
            ],
          ),
          leadingWidth: 150,
          actions: [
            Tooltip(
              message: "See Users",
              child: TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminUsersScreen(
                              username: usernameCompaniesAdmin))),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Icon(Icons.person_rounded, color: Colors.white)),
            ),
            Tooltip(
              message: "See Orders",
              child: TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminOrdersScreen(
                              username: usernameCompaniesAdmin))),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Icon(Icons.shopping_bag_rounded,
                      color: Colors.white)),
            ),
            Tooltip(
              message: "Insert Company",
              child: TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterCompanyScreen(
                              username: usernameCompaniesAdmin))),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Icon(Icons.add, color: Colors.white)),
            ),
          ],
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: const ExampleExpandableFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: RefreshIndicator(
            onRefresh: () async {
              refresh();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminCompaniesScreen(
                          username: usernameCompaniesAdmin)));
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return MySlidable3(
                  id: companies[index].id,
                  index: index,
                  tit: companies[index].name,
                  desc: companies[index].description,
                );
              },
              itemCount: companies.length,
            )),
      ),
    );
  }
}

class MySlidable3 extends StatelessWidget {
  final String tit;
  final String desc;
  final int id;
  final int index;
  const MySlidable3({
    Key? key,
    required this.tit,
    required this.desc,
    required this.id,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final companyService = Provider.of<DeleteServices>(context);
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
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (BuildContext _) async {
                await CoolAlert.show(
                  context: context,
                  type: CoolAlertType.warning,
                  title: 'Are you sure?',
                  text: "Are you sure you want to delete this company?",
                  showCancelBtn: true,
                  confirmBtnColor: Colors.red,
                  confirmBtnText: 'Delete',
                  onConfirmBtnTap: () {
                    companyService.deleteCompany(id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminCompaniesScreen(
                                username: usernameCompaniesAdmin)));
                  },
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  },
                );
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Company',
            ),
            SlidableAction(
              onPressed: (BuildContext context) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminUpdateCompanyScreen(
                            id: id,
                            name: tit,
                            description: desc,
                            username: usernameCompaniesAdmin)));
              },
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.manage_accounts_rounded,
              label: 'Edit',
            ),
          ],
        ),

        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          extentRatio: 0.6,
          motion: const ScrollMotion(),
          children: [
            Visibility(
              visible: true,
              child: SlidableAction(
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminCategoriesScreen(
                              id: id, username: usernameCompaniesAdmin)));
                },
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.category_rounded,
                label: 'Categories',
              ),
            ),
            Visibility(
              visible: true,
              child: SlidableAction(
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminSuggestionsScreen(
                              id: id, username: usernameCompaniesAdmin)));
                },
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.comment_rounded,
                label: 'Suggestions',
              ),
            ),
          ],
        ),

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
