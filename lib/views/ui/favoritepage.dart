import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/appstyle.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Favorite page",
            style: appstyle(36, Colors.black, FontWeight.bold)),
      ),
    );
  }
}
