import 'package:flutter/foundation.dart';
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
    Key? key,
    required this.male,
  }) : super(key: key);

  final Future<List<Product>> male;

  Future<void> _onRefresh(BuildContext context) async {
    try {
      Provider.of<ProductNotifier>(context, listen: false).notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error during data refresh: $error');
      }
      // Handle error appropriately (e.g., show a snackbar)
    }
  }

  Widget _buildProductTile(Product product, BuildContext context) {
    if (product.imageUrl.length >= 2) {
      return GestureDetector(
        onTap: () {
          Provider.of<ProductNotifier>(context, listen: false).productSizes = product.sizes;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductPage(id: product.id, category: product.category)),
          );
        },
        child: StaggerTile(imageUrl: product.imageUrl[1], name: product.name, price: '\$${product.price}'),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      child: FutureBuilder<List<Product>>(
        future: male,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error ${snapshot.error}");
          } else {
            final maleProducts = snapshot.data;

            return StaggeredGridView.countBuilder(
              padding: EdgeInsets.zero,
              crossAxisCount: 2,
              crossAxisSpacing: 20.w,
              mainAxisSpacing: 16.h,
              itemCount: maleProducts?.length ?? 0,
              scrollDirection: Axis.vertical,
              staggeredTileBuilder: (index) => StaggeredTile.extent(
                (index % 2 == 0) ? 1 : 1,
                (index % 4 == 1 || index % 4 == 3) ? 285.h : 252.h,
              ),
              itemBuilder: (context, index) {
                final product = maleProducts![index];
                return _buildProductTile(product, context);
              },
            );
          }
        },
      ),
    );
  }
}
