import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/controllers/mainscreen_provider.dart';
import 'package:flutter_shopping_app/views/shared/bottom_nav_widget.dart';
import 'package:flutter_shopping_app/views/ui/cartpage.dart';
import 'package:flutter_shopping_app/views/ui/favoritepage.dart';
import 'package:flutter_shopping_app/views/ui/homepage.dart';
import 'package:flutter_shopping_app/views/ui/profilepage.dart';
import 'package:flutter_shopping_app/views/ui/searchpage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  List<Widget> pageList = const [
    HomePage(),
    SearchPage(),
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
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BottomNavWidget(
                      onTap: () {
                        mainScreenNotifier.pageIndex = 0;
                      },
                      icon: Ionicons.home,
                    ),
                    BottomNavWidget(
                      onTap: () {
                        mainScreenNotifier.pageIndex = 1;
                      },
                      icon: Ionicons.search,
                    ),
                    BottomNavWidget(
                      onTap: () {
                        mainScreenNotifier.pageIndex = 2;
                      },
                      icon: Ionicons.heart,
                    ),
                    BottomNavWidget(
                      onTap: () {
                        mainScreenNotifier.pageIndex = 3;
                      },
                      icon: Ionicons.cart,
                    ),
                    BottomNavWidget(
                      onTap: () {
                        mainScreenNotifier.pageIndex = 4;
                      },
                      icon: Ionicons.person,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
