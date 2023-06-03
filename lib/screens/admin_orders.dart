// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

String? usernameOrdersAdmin;

class AdminOrdersScreen extends StatefulWidget {
  final String? username;
  const AdminOrdersScreen({Key? key, this.username}) : super(key: key);

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  List<Order> orders = [];
  final getServices = GetServices();
  Future refresh() async {
    setState(() => orders.clear());
    await getServices.getOrders();
    await getServices.getOrders();
    setState(() {
      orders = getServices.orders;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    usernameOrdersAdmin = widget.username;
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
              Icon(Icons.shopping_bag_rounded),
              SizedBox(width: 10),
              Text('Orders '),
            ],
          ),
          leadingWidth: 150,
          actions: [
            Tooltip(
              message: "Return to Companies",
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminCompaniesScreen(
                                username: widget.username)));
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
                      builder: (context) =>
                          AdminOrdersScreen(username: widget.username)));
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return MySlidable11(
                    id: orders[index].id,
                    index: index,
                    company: orders[index].company,
                    user: orders[index].user,
                    finalPrice: orders[index].finalPrice);
              },
              itemCount: orders.length,
            )),
      ),
    );
  }
}

class MySlidable11 extends StatelessWidget {
  final String company;
  final String user;
  final int id;
  final int index;
  final double finalPrice;
  const MySlidable11({
    Key? key,
    required this.company,
    required this.user,
    required this.id,
    required this.index,
    required this.finalPrice,
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
          children: [
            Visibility(
              visible: true,
              child: SlidableAction(
                onPressed: (BuildContext context) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminOrderProductsScreen(
                                username: usernameOrdersAdmin,
                                idOrder: id,
                              )));
                },
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.shopify_rounded,
                label: 'See Products',
              ),
            ),
          ],

          // All actions are defined in the children parameter.
        ),

        // The end action pane is the one at the right or the bottom side.

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: ListTile(
          title: Text('Company: $company'),
          subtitle: Text('User: $user'),
          trailing: Text('Final price with Tax: $finalPrice'),
        ));
  }

  static void goview(String route, BuildContext context) {
    Navigator.pushNamed(context, route);
  }
}
