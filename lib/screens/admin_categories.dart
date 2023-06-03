// ignore_for_file: non_constant_identifier_names

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

String? usernameCategoriesAdmin;

class AdminCategoriesScreen extends StatefulWidget {
  final int? id;
  final String? username;
  const AdminCategoriesScreen({Key? key, this.id, this.username})
      : super(key: key);

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  List<Category> categories = [];
  final getServices = GetServices();
  Future refresh() async {
    setState(() => categories.clear());
    await getServices.getCategories(widget.id);
    await getServices.getCategories(widget.id);
    setState(() {
      categories = getServices.categories;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    usernameCategoriesAdmin = widget.username;

    if (getServices.isLoading) return const LoadingScreen();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Row(
            children: const [
              SizedBox(width: 10),
              Icon(Icons.category_rounded),
              SizedBox(width: 10),
              Text('Categories  '),
            ],
          ),
          leadingWidth: 150,
          actions: [
            Tooltip(
              message: "Insert Category",
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminInsertCategoryScreen(
                                id: widget.id,
                                username: usernameCategoriesAdmin)));
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Icon(Icons.add, color: Colors.white)),
            ),
            Tooltip(
              message: "Return to Companies",
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminCompaniesScreen(
                                username: usernameCategoriesAdmin)));
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child:
                      const Icon(Icons.business_rounded, color: Colors.white)),
            )
          ],
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
                      builder: (context) => AdminCategoriesScreen(
                          id: widget.id, username: usernameCategoriesAdmin)));
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return MySlidable(
                  idCompany: widget.id,
                  id: categories[index].id,
                  index: index,
                  tit: categories[index].name,
                  desc: categories[index].description,
                );
              },
              itemCount: categories.length,
            )),
      ),
    );
  }
}

class MySlidable extends StatelessWidget {
  final int? idCompany;
  final String tit;
  final String desc;
  final int id;
  final int index;
  const MySlidable({
    Key? key,
    this.idCompany,
    required this.tit,
    required this.desc,
    required this.id,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deleteServices = Provider.of<DeleteServices>(context);
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
                  text: "Are you sure you want to delete this category?",
                  showCancelBtn: true,
                  confirmBtnColor: Colors.red,
                  confirmBtnText: 'Delete',
                  onConfirmBtnTap: () {
                    deleteServices.deleteCategory(id);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminCategoriesScreen(
                                id: idCompany,
                                username: usernameCategoriesAdmin)));
                  },
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  },
                );
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Category',
            ),
            SlidableAction(
              onPressed: (BuildContext context) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminUpdateCategoryScreen(
                            idCompany: idCompany,
                            idCategory: id,
                            name: tit,
                            description: desc,
                            username: usernameCategoriesAdmin)));
              },
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.category_rounded,
              label: 'Edit',
            ),
          ],
        ),

        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            Visibility(
              visible: true,
              child: SlidableAction(
                onPressed: (BuildContext _) async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminProductsScreen(
                              idCompany: idCompany,
                              idCategory: id,
                              username: usernameCategoriesAdmin)));
                },
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.shopify,
                label: 'See Products',
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
