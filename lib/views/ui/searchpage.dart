import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/appstyle.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Search page",
            style: appstyle(36, Colors.black, FontWeight.bold)),
      ),
    );
  }
}
