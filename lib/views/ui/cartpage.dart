import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/appstyle.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Cart page",
            style: appstyle(36, Colors.black, FontWeight.bold)),
      ),
    );
  }
}
