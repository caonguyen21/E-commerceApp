import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/views/shared/stagger_tile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../models/product.dart';

class LatesProduct extends StatelessWidget {
  const LatesProduct({
    super.key,
    required Future<List<Product>> male,
  }) : _male = male;

  final Future<List<Product>> _male;

  @override
  Widget build(BuildContext context) {
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
            crossAxisSpacing: 20,
            mainAxisSpacing: 16,
            itemCount: male!.length,
            scrollDirection: Axis.vertical,
            staggeredTileBuilder: (index) => StaggeredTile.extent(
              (index % 2 == 0) ? 1 : 1,
              (index % 4 == 1 || index % 4 == 3)
                  ? MediaQuery.of(context).size.height * 0.35
                  : MediaQuery.of(context).size.height * 0.31,
            ),
            itemBuilder: (context, index) {
              final shoes = snapshot.data![index];

              // Make sure that shoes.imageUrl has at least two elements
              if (shoes.imageUrl.length >= 2) {
                return StaggerTile(
                    imageUrl: shoes.imageUrl[1],
                    name: shoes.name,
                    price: "\$${shoes.price}");
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
