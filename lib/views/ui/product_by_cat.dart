import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/views/shared/category_btn.dart';
import 'package:flutter_shopping_app/views/shared/custom_spacer.dart';
import 'package:flutter_shopping_app/views/shared/lates_product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../controllers/product_provider.dart';
import '../shared/appstyle.dart';

class ProductByCat extends StatefulWidget {
  const ProductByCat({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  State<ProductByCat> createState() => _ProductByCatState();
}

class _ProductByCatState extends State<ProductByCat> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = widget.tabIndex;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> brand = ["assets/images/adidas.png", "assets/images/gucci.png", "assets/images/jordan.png", "assets/images/nike.png"];

  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);
    productNotifier.getMale();
    productNotifier.getFemale();
    productNotifier.getKids();
    return Scaffold(
        backgroundColor: const Color(0xFFE2E2E2),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 45.h, 0, 0),
                height: 325.h,
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/top_image.png"), fit: BoxFit.fill)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(6.w, 12.h, 16.w, 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              filter();
                            },
                            child: const Icon(
                              FontAwesomeIcons.sliders,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
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
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.185, left: 16, right: 12),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      LatesProduct(male: productNotifier.male),
                      LatesProduct(male: productNotifier.female),
                      LatesProduct(male: productNotifier.kids),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<dynamic> filter() {
    double value = 100;
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.white54,
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.84,
              decoration: const BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 5,
                    width: 40,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.black38),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                      children: [
                        const CustomSpacer(),
                        Text(
                          "Filter",
                          style: appstyle(40, Colors.black, FontWeight.bold),
                        ),
                        const CustomSpacer(),
                        Text(
                          "Gender",
                          style: appstyle(20, Colors.black, FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: const [
                            CategoryBtn(buttonColor: Colors.black, label: "Men"),
                            CategoryBtn(buttonColor: Colors.grey, label: "Women"),
                            CategoryBtn(buttonColor: Colors.grey, label: "Kids"),
                          ],
                        ),
                        const CustomSpacer(),
                        Text(
                          "Category",
                          style: appstyle(20, Colors.black, FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: const [
                            CategoryBtn(buttonColor: Colors.black, label: "Shoes"),
                            CategoryBtn(buttonColor: Colors.grey, label: "Apparrels"),
                            CategoryBtn(buttonColor: Colors.grey, label: "Accessori"),
                          ],
                        ),
                        const CustomSpacer(),
                        Text(
                          "Price",
                          style: appstyle(20, Colors.black, FontWeight.bold),
                        ),
                        const CustomSpacer(),
                        Slider(
                            value: value,
                            activeColor: Colors.black,
                            inactiveColor: Colors.grey,
                            thumbColor: Colors.black,
                            max: 500,
                            divisions: 50,
                            label: value.toString(),
                            secondaryTrackValue: 200,
                            onChanged: (d) {}),
                        const CustomSpacer(),
                        Text(
                          "Brand",
                          style: appstyle(20, Colors.black, FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          height: 80,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: brand.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200, borderRadius: const BorderRadius.all(Radius.circular(12))),
                                    child: Image.asset(
                                      brand[index],
                                      color: Colors.black,
                                      height: 60,
                                      width: 80,
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
  }
}
