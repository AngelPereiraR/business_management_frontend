// ignore_for_file: non_constant_identifier_names

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

int? idCompanyProductsAdmin;
int? idCategoryProductsAdmin;
String? usernameProductsAdmin;

class AdminProductsScreen extends StatefulWidget {
  final int? idCompany;
  final String? username;
  final int? idCategory;
  const AdminProductsScreen(
      {Key? key, this.idCompany, this.idCategory, this.username})
      : super(key: key);

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  List<Product> products = [];
  final getServices = GetServices();
  Future refresh() async {
    setState(() => products.clear());
    await getServices.getProductsFromCategory(widget.idCategory);
    await getServices.getProductsFromCategory(widget.idCategory);
    setState(() {
      products = getServices.products2;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    idCompanyProductsAdmin = widget.idCompany;
    idCategoryProductsAdmin = widget.idCategory;
    usernameProductsAdmin = widget.username;
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
              Icon(Icons.shopify_rounded),
              SizedBox(width: 10),
              Text('Products  '),
            ],
          ),
          leadingWidth: 150,
          actions: [
            Tooltip(
              message: "Insert Product",
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminInsertProductScreen(
                                  idCompany: widget.idCompany,
                                  idCategory: widget.idCategory,
                                  username: usernameProductsAdmin,
                                )));
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Icon(Icons.add, color: Colors.white)),
            ),
            Tooltip(
              message: "Return to Categories",
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminCategoriesScreen(
                                  id: widget.idCompany,
                                  username: usernameProductsAdmin,
                                )));
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child:
                      const Icon(Icons.category_rounded, color: Colors.white)),
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
                      builder: (context) => AdminProductsScreen(
                          idCompany: widget.idCompany,
                          idCategory: widget.idCategory)));
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return MySlidable2(
                  id: products[index].id,
                  index: index,
                  tit: products[index].name,
                  desc: products[index].description,
                  price: products[index].price,
                );
              },
              itemCount: products.length,
            )),
      ),
    );
  }
}

class MySlidable2 extends StatelessWidget {
  final String tit;
  final String desc;
  final int id;
  final int index;
  final double price;
  const MySlidable2({
    Key? key,
    required this.tit,
    required this.desc,
    required this.id,
    required this.index,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deleteProductService = Provider.of<DeleteServices>(context);
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
                  text: "Are you sure you want to delete this product?",
                  showCancelBtn: true,
                  confirmBtnColor: Colors.red,
                  confirmBtnText: 'Delete',
                  onConfirmBtnTap: () {
                    deleteProductService.deleteProduct(id);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminProductsScreen(
                                  idCompany: idCompanyProductsAdmin,
                                  idCategory: idCategoryProductsAdmin,
                                  username: usernameProductsAdmin,
                                )));
                  },
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  },
                );
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
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
                onPressed: (BuildContext context) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminUpdateProductScreen(
                                idCompany: idCompanyProductsAdmin,
                                idCategory: idCategoryProductsAdmin,
                                idProduct: id,
                                nameProduct: tit,
                                descriptionProduct: desc,
                                priceProduct: price,
                                username: usernameProductsAdmin,
                              )));
                },
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.manage_accounts_rounded,
                label: 'Edit',
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
