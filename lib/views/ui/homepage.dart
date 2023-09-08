import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/views/shared/appstyle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Home page",
            style: appstyle(36, Colors.black, FontWeight.bold)),
      ),
    );
  }
}
