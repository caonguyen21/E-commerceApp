import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/controllers/product_provider.dart';
import 'package:flutter_shopping_app/views/shared/reusableText.dart';
import 'package:flutter_shopping_app/views/shared/widget/shimmer_effect.dart';
import 'package:flutter_shopping_app/views/ui/page/product_page.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../../ui/page/product_by_cat.dart';
import '../appstyle.dart';
import 'new_product.dart';
import 'product_card.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    required Future<List<Products>> male,
    required this.tabIndex,
  }) : _male = male;

  final Future<List<Products>> _male;
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 335.h,
            child: FutureBuilder<List<Products>>(
              future: _male,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return shimmerForProductCard();
                } else if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                } else {
                  final male = snapshot.data;
                  return ListView.builder(
                    itemCount: male!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          productNotifier.productSizes = (product.sizes).cast<Map<String, dynamic>>();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                        product: product,
                                      )));
                        },
                        child: ProductCard(
                          price: "\$${product.price}",
                          category: product.category,
                          name: product.name,
                          image: product.imageUrl[0],
                          id: product.id,
                          title: product.title,
                          oldPrice: product.oldPrice,
                          sizes: product.sizes.join(', '),
                          description: product.description,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableText(
                      text: "Latest Shoes",
                      style: appstyle(24, Colors.black, FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductByCat(tabIndex: tabIndex),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          ReusableText(
                            text: "Show All",
                            style: appstyle(22, Colors.black, FontWeight.w500),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 25.h,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 100.h,
            child: FutureBuilder<List<Products>>(
              future: _male,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return shimmerForNewProduct();
                } else if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                } else {
                  final male = snapshot.data;
                  return ListView.builder(
                    itemCount: male!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];

                      // Check if imageUrl is not empty and contains at least two elements
                      if (product.imageUrl.isNotEmpty && product.imageUrl.length > 1) {
                        return GestureDetector(
                          onTap: () {
                            productNotifier.productSizes = (product.sizes).cast<Map<String, dynamic>>();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(product: product)));
                          },
                          child: NewProduct(
                            imageUrl: product.imageUrl[1],
                          ),
                        );
                      } else {
                        // Handle the case where imageUrl is empty or doesn't have enough elements
                        return const SizedBox(); // or another fallback widget
                      }
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
