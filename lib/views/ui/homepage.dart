import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/controllers/login_provider.dart';
import 'package:flutter_shopping_app/controllers/product_provider.dart';
import 'package:flutter_shopping_app/views/shared/home_widget.dart';
import 'package:flutter_shopping_app/views/shared/reusableText.dart';
import 'package:provider/provider.dart';

import '../shared/appstyle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    setState(() {
      var authNotifier = Provider.of<LoginNotifier>(context, listen: false);
      authNotifier.getPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);
    productNotifier.getMale();
    productNotifier.getFemale();
    productNotifier.getKids();
    return Scaffold(
        backgroundColor: const Color(0xFFE2E2E2),
        body: SizedBox(
          height: 812.h,
          width: 375.w,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 45.h, 0, 0),
                height: 325.h,
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/top_image.png"), fit: BoxFit.fill)),
                child: Container(
                  padding: EdgeInsets.only(left: 8.w, bottom: 15.h),
                  width: 375.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(text: "Meadow Store", style: appstyleWithHt(42, Colors.white, FontWeight.bold, 1.5)),
                      ReusableText(text: "Collection", style: appstyleWithHt(42, Colors.white, FontWeight.bold, 1.2)),
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
                padding: EdgeInsets.only(top: 203.h),
                child: Container(
                  padding: EdgeInsets.only(left: 12.w),
                  child: TabBarView(controller: _tabController, children: [
                    HomeWidget(
                      male: productNotifier.male,
                      tabIndex: 0,
                    ),
                    HomeWidget(
                      male: productNotifier.female,
                      tabIndex: 1,
                    ),
                    HomeWidget(
                      male: productNotifier.kids,
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
