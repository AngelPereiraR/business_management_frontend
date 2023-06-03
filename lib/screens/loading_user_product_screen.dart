import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../screens/screens.dart';

class LoadingUserProductScreen extends StatefulWidget {
  final int? id;
  final String? username;
  final String? companyUser;
  const LoadingUserProductScreen(
      {Key? key, this.username, this.id, this.companyUser})
      : super(key: key);

  @override
  State<LoadingUserProductScreen> createState() =>
      _LoadingUserProductScreenState();
}

class _LoadingUserProductScreenState extends State<LoadingUserProductScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProductScreen(
                  username: widget.username,
                  id: widget.id,
                  companyUser: widget.companyUser,
                )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: SpinKitWave(color: Color.fromRGBO(0, 153, 153, 1), size: 50)),
    );
  }
}
