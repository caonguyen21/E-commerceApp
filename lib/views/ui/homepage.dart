import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/services/helper.dart';
import 'package:flutter_shopping_app/views/shared/home_widget.dart';

import '../../models/product.dart';
import '../shared/appstyle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  late Future<List<Product>> _male;
  late Future<List<Product>> _female;
  late Future<List<Product>> _kids;

  void getMale() {
    _male = Helper().getMaleProducts();
  }

  void getFemale() {
    _female = Helper().getFemaleProducts();
  }

  void getKids() {
    _kids = Helper().getKidsProducts();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getMale();
    getFemale();
    getKids();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE2E2E2),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 45, 0, 0),
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/top_image.png"), fit: BoxFit.fill)),
                child: Container(
                  padding: const EdgeInsets.only(left: 8, bottom: 15),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Meadow Store",
                        style: appstyleWithHt(46, Colors.white, FontWeight.bold, 1.5),
                      ),
                      Text("Collection", style: appstyleWithHt(36, Colors.white, FontWeight.bold, 1.2)),
                      TabBar(
                          padding: EdgeInsets.zero,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Colors.transparent,
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: Colors.white,
                          labelStyle: appstyle(24, Colors.white, FontWeight.bold),
                          unselectedLabelColor: Colors.grey.withOpacity(0.3),
                          tabs: const [
                            Tab(
                              text: "Man Shoes",
                            ),
                            Tab(
                              text: "Women Shoes",
                            ),
                            Tab(
                              text: "Kids Shoes",
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.265),
                child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  child: TabBarView(controller: _tabController, children: [
                    HomeWidget(
                      male: _male,
                      tabIndex: 0,
                    ),
                    HomeWidget(
                      male: _female,
                      tabIndex: 1,
                    ),
                    HomeWidget(
                      male: _kids,
                      tabIndex: 2,
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ));
  }
}
