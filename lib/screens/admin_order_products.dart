// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

String? usernameOrderProductsAdmin;

class AdminOrderProductsScreen extends StatefulWidget {
  final int? idOrder;
  final String? username;
  const AdminOrderProductsScreen({Key? key, this.username, this.idOrder})
      : super(key: key);

  @override
  State<AdminOrderProductsScreen> createState() =>
      _AdminOrderProductsScreenState();
}

class _AdminOrderProductsScreenState extends State<AdminOrderProductsScreen> {
  Order? order;
  final getServices = GetServices();
  Future refresh() async {
    await getServices.getOrder(widget.idOrder);
    await getServices.getOrder(widget.idOrder);
    setState(() {
      order = getServices.order;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    usernameOrderProductsAdmin = widget.username;
    if (getServices.isLoading) return const LoadingScreen();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Row(
            children: [
              const SizedBox(width: 10),
              const Icon(Icons.shopify_rounded),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  const Text('Products from Order'),
                  Text('Final Price with Tax: ${order?.finalPrice}')
                ],
              ))
            ],
          ),
          leadingWidth: 450,
          actions: [
            Tooltip(
              message: "Return to Orders",
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AdminOrdersScreen(username: widget.username)));
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Icon(Icons.shopping_bag_rounded,
                      color: Colors.white)),
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
                      builder: (context) => AdminOrderProductsScreen(
                            username: widget.username,
                            idOrder: widget.idOrder,
                          )));
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return MySlidable13(
                    id: order!.products[index].id,
                    index: index,
                    name: order!.products[index].name,
                    description: order!.products[index].description,
                    price: order!.products[index].price,
                    quantity: order!.quantities[index]);
              },
              itemCount: order?.products.length,
            )),
      ),
    );
  }
}

class MySlidable13 extends StatelessWidget {
  final String name;
  final String description;
  final int id;
  final int index;
  final double price;
  final String quantity;
  const MySlidable13({
    Key? key,
    required this.name,
    required this.description,
    required this.id,
    required this.index,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
        enabled: false,

        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () {}),
          dragDismissible: false, children: const [],

          // All actions are defined in the children parameter.
        ),

        // The end action pane is the one at the right or the bottom side.

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: ListTile(
          title: Text('Company: $name'),
          subtitle: Text('Quantity: $quantity'),
        ));
  }

  static void goview(String route, BuildContext context) {
    Navigator.pushNamed(context, route);
  }
}
