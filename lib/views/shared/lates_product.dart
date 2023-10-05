import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/views/shared/shimmer_loading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../controllers/product_provider.dart';
import '../../models/product.dart';
import '../shared/stagger_tile.dart';
import '../ui/product_page.dart';

class LatestProduct extends StatelessWidget {
  const LatestProduct({
    Key? key,
    required this.male,
  }) : super(key: key);

  final Future<List<Product>> male;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: male,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingShimmer(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          final maleProducts = snapshot.data;
          return _buildProductGrid(maleProducts);
        }
      },
    );
  }

  Widget _buildProductTile(Product product, BuildContext context) {
    if (product.imageUrl.length >= 2) {
      return GestureDetector(
        onTap: () {
          Provider.of<ProductNotifier>(context, listen: false).productSizes = product.sizes;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(
                product: product,
              ),
            ),
          );
        },
        child: StaggerTile(imageUrl: product.imageUrl[1], name: product.name, price: '\$${product.price}'),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildLoadingShimmer(List<Product>? maleProducts) {
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
        return Container(
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Padding(padding: EdgeInsets.all(8.h), child: const ShimmerLoading()));
      },
    );
  }

  Widget _buildErrorWidget(dynamic error) {
    return Center(
      child: Text("Error: $error"),
    );
  }

  Widget _buildProductGrid(List<Product>? maleProducts) {
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
}
