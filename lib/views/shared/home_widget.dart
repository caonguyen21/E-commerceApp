import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../ui/product_by_cat.dart';
import 'appstyle.dart';
import 'new_product.dart';
import 'product_cart.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    required Future<List<Product>> male,
  }) : _male = male;

  final Future<List<Product>> _male;

  @override
  Widget build(BuildContext context) {
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
                    final shoes = snapshot.data![index];
                    return ProductCart(
                      price: "\$${shoes.price}",
                      category: shoes.category,
                      name: shoes.name,
                      image: shoes.imageUrl[0],
                      id: shoes.id,
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
                    onTap: (){
                      const ProductByCat();
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
                    final shoes = snapshot.data![index];

                    // Check if imageUrl is not empty and contains at least two elements
                    if (shoes.imageUrl.isNotEmpty &&
                        shoes.imageUrl.length > 1) {
                      return NewProduct(
                        imageUrl: shoes.imageUrl[1],
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
