import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/controllers/product_provider.dart';
import 'package:flutter_shopping_app/views/ui/product_page.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../ui/product_by_cat.dart';
import 'appstyle.dart';
import 'new_product.dart';
import 'product_cart.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    required Future<List<Product>> male,
    required this.tabIndex,
  }) : _male = male;

  final Future<List<Product>> _male;
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.405,
          child: FutureBuilder<List<Product>>(
            future: _male,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
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
                        productNotifier.productSizes = product.sizes;
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => ProductPage(id: product.id, category: product.category)));
                      },
                      child: ProductCart(
                        price: "\$${product.price}",
                        category: product.category,
                        name: product.name,
                        image: product.imageUrl[0],
                        id: product.id,
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
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Latest Shoes",
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
                        Text(
                          "Show All",
                          style: appstyle(22, Colors.black, FontWeight.w500),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 25,
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
          height: MediaQuery.of(context).size.height * 0.13,
          child: FutureBuilder<List<Product>>(
            future: _male,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
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
                          productNotifier.productSizes = product.sizes;
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => ProductPage(id: product.id, category: product.category)));
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
    );
  }
}
