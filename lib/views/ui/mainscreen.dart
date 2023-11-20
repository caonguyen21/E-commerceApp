import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/controllers/mainscreen_provider.dart';
import 'package:flutter_shopping_app/views/ui/page/favoritepage.dart';
import 'package:flutter_shopping_app/views/ui/page/homepage.dart';
import 'package:flutter_shopping_app/views/ui/page/profilepage.dart';
import 'package:flutter_shopping_app/views/ui/page/searchpage.dart';
import 'package:provider/provider.dart';

import '../shared/widget/bottom_nav.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final List<Widget> pageList = [
    const HomePage(),
    const SearchPage(),
    const FavoritePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE2E2E2),
          body: pageList[mainScreenNotifier.pageIndex],
          bottomNavigationBar: const BottomNavbar(),
        );
      },
    );
  }
}
