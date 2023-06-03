import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const _ColorBox(),
          const HeaderIcon(),
          child,
        ],
      ),
    );
  }
}

class HeaderIcon extends StatelessWidget {
  const HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: const Icon(Icons.person_pin_rounded,
            color: Colors.white, size: 100),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  const _ColorBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        height: size.height * 0.4,
        decoration: _buildBoxDecoration(),
        child: Stack(
          children: [
            Positioned(top: 90, left: 30, child: _Bubble()),
            Positioned(top: -40, left: 20, child: _Bubble()),
            Positioned(top: -50, right: -30, child: _Bubble()),
            Positioned(bottom: -50, left: 15, child: _Bubble()),
            Positioned(bottom: 90, right: 20, child: _Bubble()),
          ],
        ));
  }

  BoxDecoration _buildBoxDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(colors: [
        Color.fromARGB(197, 17, 193, 134),
        Color.fromARGB(155, 11, 134, 89)
      ]),
    );
  }
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}
