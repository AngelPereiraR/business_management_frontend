// ignore_for_file: unused_element, camel_case_types, import_of_legacy_library_into_null_safe, use_build_context_synchronously

import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../screens/screens.dart';

import '../models/models.dart';
import '../services/services.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

var _counter = 0;
int? idProductCartScreen;
String? usernameProductCartScreen;
String? companyUserProductCartScreen;
List<ProductCart> productCartList2 = <ProductCart>[];

class ProductCartScreen extends StatefulWidget {
  final String? companyUser;
  final int? id;
  final String? username;
  final List<ProductCart> productCartList;
  const ProductCartScreen(
      {Key? key,
      this.id,
      this.username,
      required this.productCartList,
      required this.companyUser})
      : super(key: key);

  @override
  State<ProductCartScreen> createState() => _ProductCartScreenState();
}

class _ProductCartScreenState extends State<ProductCartScreen> {
  List<Product> products = [];
  List<Category> categories = [];
  final getService = GetServices();

  Future refresh() async {
    setState(() => products.clear());
    await getService.getProductsFromCompany(widget.id);

    setState(() {
      products = getService.products3;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    idProductCartScreen = widget.id;
    usernameProductCartScreen = widget.username;
    getService.isLoading = false;
    productCartList2 = widget.productCartList;
    companyUserProductCartScreen = widget.companyUser;
    return getService.isLoading
        ? const Center(
            child: SpinKitWave(color: Color.fromRGBO(0, 153, 153, 1), size: 50))
        : Scaffold(
            appBar: _appbar(context),
            body: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(height: 5),
                      // const ProductsSearchUser(),
                      listProducts3()
                    ],
                  )
                ],
              ),
            ));
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductScreen(
                        username: widget.username,
                        id: widget.id,
                        companyUser: widget.companyUser,
                      )));
        },
        icon: const Icon(Icons.keyboard_return_rounded),
      ),
    );
  }
}

class listProducts3 extends StatefulWidget {
  const listProducts3({super.key});

  @override
  State<listProducts3> createState() => _listProductsState();
}

class _listProductsState extends State<listProducts3> {
  List<Product> products = [];
  List<ProductItem> productItems = [];
  late Company? company;
  List<User> users = [];
  late User? user;
  final getService = GetServices();
  int minQuantity = 1;
  Future refresh() async {
    setState(() => products.clear());
    await getService.getProductsFromCompany(idProductCartScreen);
    await getService.getCompanyFromUser(companyUserProductCartScreen);
    await getService.getUsers();
    setState(() {
      products = getService.products3;
      productItems =
          products.map((product) => ProductItem(selectedQuantity: 1)).toList();
      company = getService.company;
      users = getService.users;
    });
    for (User userItem in users) {
      if (userItem.username == usernameProductCartScreen) {
        user = userItem;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    double finalPrice = 0.0;
    for (ProductCart productCart in productCartList2) {
      finalPrice += productCart.totalPrice;
    }

    double finalPriceWithTax = 0;

    final insertServices = Provider.of<InsertServices>(context);
    final getServices = Provider.of<GetServices>(context);
    final updateServices = Provider.of<UpdateServices>(context);

    void generatePDF() async {
      final pdf = pw.Document();

      // Crear la fuente Roboto
      final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
      var myFont = pw.Font.ttf(fontData);

      // Crear la tabla
      final headers = ['Name', 'Description', 'Quantity', 'Total Price'];
      final data = productCartList2.map((productCart) {
        final product = productCart.product;
        final quantity = productCart.quantity;
        final totalPrice = productCart.totalPrice;
        return [
          product.name,
          product.description,
          quantity.toString(),
          totalPrice.toString()
        ];
      }).toList();

      final headers2 = ['Name', 'Description'];
      final data2 = [
        [company?.name, company?.description]
      ];

      final headers3 = ['Username', 'Email'];
      final data3 = [
        [user?.username, user?.email]
      ];

      // Calcular el finalPrice
      final finalPrice = productCartList2.fold<double>(
          0, (sum, productCart) => sum + productCart.totalPrice);

      // Calcular el finalPrice multiplicado por 1.21
      finalPriceWithTax = double.parse((finalPrice * 1.21).toStringAsFixed(2));

      // Añadir la tabla al documento
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Column(children: [
          pw.Text('Order made:', style: pw.TextStyle(font: myFont)),
          pw.SizedBox(height: 10),
          pw.Text('Company:', style: pw.TextStyle(font: myFont)),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: headers2,
            data: data2,
            headerAlignment: pw.Alignment.centerLeft,
            cellAlignment: pw.Alignment.centerLeft,
            headerStyle: pw.TextStyle(
              font: myFont,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: pw.TextStyle(font: myFont),
          ),
          pw.SizedBox(height: 10),
          pw.Text('User:', style: pw.TextStyle(font: myFont)),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: headers3,
            data: data3,
            headerAlignment: pw.Alignment.centerLeft,
            cellAlignment: pw.Alignment.centerLeft,
            headerStyle: pw.TextStyle(
              font: myFont,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: pw.TextStyle(font: myFont),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Products:', style: pw.TextStyle(font: myFont)),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: headers,
            data: data,
            headerAlignment: pw.Alignment.centerLeft,
            cellAlignment: pw.Alignment.centerLeft,
            headerStyle: pw.TextStyle(
              font: myFont,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: pw.TextStyle(font: myFont),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Final Price without Tax: $finalPrice €',
              style: pw.TextStyle(font: myFont, fontSize: 12)),
          pw.SizedBox(height: 10),
          pw.Text('Final Price with Tax: $finalPriceWithTax €',
              style: pw.TextStyle(font: myFont, fontSize: 12)),
        ], crossAxisAlignment: pw.CrossAxisAlignment.start);
      }));

      // Verificar y solicitar permiso si aún no se ha concedido
      if (await Permission.storage.request().isGranted) {
        // Obtener la ruta del directorio de descargas en Android
        Directory? directorioDescargas = await getExternalStorageDirectory();
        String? rutaDescargas = directorioDescargas?.path;

        // Crear un nuevo archivo en la ruta de descargas
        File archivoPDF = File('$rutaDescargas/pedido.pdf');

        await archivoPDF.writeAsBytes(await pdf.save());

        String rutaArchivoPDF = '$rutaDescargas/pedido.pdf';

        Share.shareFiles([rutaArchivoPDF]);

        // Mostrar un mensaje de descarga exitosa
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('PDF descargado con éxito'),
        ));
      } else {
        // El permiso no se ha concedido. Mostrar mensaje de error o solicitar permiso nuevamente.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'No se pudo descargar el PDF. Se requiere permiso de almacenamiento.'),
        ));
      }
    }

    return Form(
      key: GlobalKey<FormState>(),
      child: Column(
        children: [
          Visibility(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 525,
                width: 400,
                child: GridView.builder(
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: 10,
                          height: 330,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              // ignore: prefer_const_literals_to_create_immutables
                              boxShadow: [
                                const BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 5,
                                  offset: Offset(0, 0),
                                )
                              ]),
                          child: Column(
                            children: [
                              Row(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Tooltip(
                                    message:
                                        productCartList2[index].product.name,
                                    child: Text(
                                      productCartList2[index]
                                                  .product
                                                  .name
                                                  .length <=
                                              15
                                          ? productCartList2[index].product.name
                                          : "${productCartList2[index].product.name.substring(0, 15)}...",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Tooltip(
                                    message: productCartList2[index]
                                        .product
                                        .description,
                                    child: Text(
                                      productCartList2[index]
                                                  .product
                                                  .description
                                                  .length <=
                                              15
                                          ? productCartList2[index]
                                              .product
                                              .description
                                          : "${productCartList2[index].product.description.substring(0, 15)}...",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                      onTap: () {
                                        productCartList
                                            .remove(productCartList[index]);
                                        CoolAlert.show(
                                          barrierDismissible: false,
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Product deleted from cart",
                                          borderRadius: 30,
                                          //loopAnimation: true,
                                          onConfirmBtnTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoadingUserProductScreen(
                                                          username:
                                                              usernameProductScreen,
                                                          id: idProductScreen,
                                                          companyUser:
                                                              companyUserProductScreen)),
                                            );
                                          },
                                          confirmBtnColor: Colors.blue,
                                        );
                                      },
                                      child: const Icon(
                                        Icons.remove_shopping_cart_rounded,
                                        size: 35,
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 0.5,
                                color: Colors.black54,
                              ),
                              Row(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    'Price per product: ${productCartList2[index].product.price} €',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    maxLines: 2,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Quantity: ${productCartList2[index].quantity}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Total price: ${productCartList2[index].totalPrice} €",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  itemCount: productCartList2.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisExtent: 160,
                      mainAxisSpacing: 10),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsetsDirectional.only(
                  start: 40,
                  top: 20,
                ),
                height: 50,
                width: 340,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 255, 255)),
                      minimumSize:
                          MaterialStateProperty.all(const Size(50, 50))),
                  onPressed: () {},
                  child: Text('Total price of all products: $finalPrice €',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsetsDirectional.only(
                  start: 40,
                  top: 20,
                ),
                height: 50,
                width: 340,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 235, 9, 9)),
                      minimumSize:
                          MaterialStateProperty.all(const Size(50, 50))),
                  onPressed: () {
                    productCartList2.clear();
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoadingUserProductScreen(
                                  username: usernameProductCartScreen,
                                  id: idProductCartScreen,
                                )));
                  },
                  child: const Text('Empty shopping cart',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsetsDirectional.only(
                  start: 40,
                  top: 20,
                ),
                height: 50,
                width: 340,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 18, 201, 159)),
                      minimumSize:
                          MaterialStateProperty.all(const Size(50, 50))),
                  onPressed: () async {
                    generatePDF();

                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.confirm,
                        text: 'Are you sure you want to make this order?',
                        borderRadius: 30,
                        confirmBtnColor: Colors.blue,
                        onConfirmBtnTap: () async {
                          await insertServices.insertOrder(
                              finalPriceWithTax, company?.id, user?.username);

                          await getServices.getOrders();

                          List<Order> orders = getServices.orders;

                          for (int i = 0; i < productCartList2.length; i++) {
                            await updateServices.insertProductIntoOrder(
                                orders.last.id,
                                productCartList2[i].product.id,
                                productCartList2[i].quantity.toString());
                          }
                          Navigator.pop(context);
                        });
                  },
                  child: const Text('Make an order',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
