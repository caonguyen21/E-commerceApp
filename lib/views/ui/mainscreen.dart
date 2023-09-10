import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/controllers/mainscreen_provider.dart';
import 'package:flutter_shopping_app/views/ui/cartpage.dart';
import 'package:flutter_shopping_app/views/ui/favoritepage.dart';
import 'package:flutter_shopping_app/views/ui/homepage.dart';
import 'package:flutter_shopping_app/views/ui/product_by_cat.dart';
import 'package:flutter_shopping_app/views/ui/profilepage.dart';
import 'package:flutter_shopping_app/views/ui/searchpage.dart';
import 'package:provider/provider.dart';

import '../shared/bottom_nav.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  List<Widget> pageList = const [
    HomePage(),
    SearchPage(),
    ProductByCat(),
    FavoritePage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child) {
        return Scaffold(
          backgroundColor: Color(0xFFE2E2E2),
          body: pageList[mainScreenNotifier.pageIndex],
          bottomNavigationBar: const BottomNavbar(),
        );
      },
    );
  }
}
