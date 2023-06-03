import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gestion_empresas/screens/screens.dart';

class LoadingCompanyScreen extends StatefulWidget {
  final String? username;
  const LoadingCompanyScreen({Key? key, this.username}) : super(key: key);

  @override
  State<LoadingCompanyScreen> createState() => _LoadingCompanyScreenState();
}

class _LoadingCompanyScreenState extends State<LoadingCompanyScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CompanyScreen(
                  username: widget.username,
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
