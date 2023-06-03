import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: _createCardShape(),
        child: child,
      ),
    );
  }

  BoxDecoration _createCardShape() =>
      BoxDecoration(borderRadius: BorderRadius.circular(25),
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(197, 17, 193, 134),
              blurRadius: 15,
              offset: Offset(0, 0),
            )
          ]);
}
