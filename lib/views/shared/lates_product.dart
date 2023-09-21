import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/views/shared/stagger_tile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../controllers/product_provider.dart';
import '../../models/product.dart';
import '../ui/product_page.dart';

class LatesProduct extends StatelessWidget {
  const LatesProduct({
    super.key,
    required Future<List<Product>> male,
  }) : _male = male;

  final Future<List<Product>> _male;

  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);
    return FutureBuilder<List<Product>>(
      future: _male,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error ${snapshot.error}");
        } else {
          final male = snapshot.data;

          return StaggeredGridView.countBuilder(
            padding: EdgeInsets.zero,
            crossAxisCount: 2,
            crossAxisSpacing: 20.w,
            mainAxisSpacing: 16.h,
            itemCount: male!.length,
            scrollDirection: Axis.vertical,
            staggeredTileBuilder: (index) => StaggeredTile.extent(
              (index % 2 == 0) ? 1 : 1,
              (index % 4 == 1 || index % 4 == 3) ? 285.h : 252.h,
            ),
            itemBuilder: (context, index) {
              final product = snapshot.data![index];

              // Make sure that product.imageUrl has at least two elements
              if (product.imageUrl.length >= 2) {
                return GestureDetector(
                  onTap: () {
                    productNotifier.productSizes = product.sizes;
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ProductPage(id: product.id, category: product.category)));
                  },
                  child: StaggerTile(imageUrl: product.imageUrl[1], name: product.name, price: "\$${product.price}"),
                );
              } else {
                // Handle the case where imageUrl doesn't have enough elements
                return const SizedBox();
              }
            },
          );
        }
      },
    );
  }
}
