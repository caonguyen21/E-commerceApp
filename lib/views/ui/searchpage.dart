import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/controllers/product_provider.dart';
import 'package:flutter_shopping_app/services/helper.dart';
import 'package:flutter_shopping_app/views/shared/appstyle.dart';
import 'package:flutter_shopping_app/views/ui/product_page.dart';
import 'package:provider/provider.dart';

import '../shared/custom_field.dart';
import '../shared/reusableText.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController search = TextEditingController();

  void _refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomField(
          hintText: 'Search for a product',
          controller: search,
          onEditingComplete: () {
            setState(() {});
          },
          prefixIcon: GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.black,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          onRefresh: _refreshData,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    var productProvider = Provider.of<ProductNotifier>(context);

    if (search.text.isEmpty) {
      return Center(
        child: Text(
          'No items in search',
          style: appstyle(28, Colors.black, FontWeight.bold),
        ),
      );
    }

    return FutureBuilder(
      future: Helper().search(search.text),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: ReusableText(
              text: 'Error retrieving the data',
              style: appstyle(20, Colors.black, FontWeight.bold),
            ),
          );
        } else if (snapshot.data!.isEmpty) {
          return Center(
            child: ReusableText(
              text: 'Product not found',
              style: appstyle(20, Colors.black, FontWeight.bold),
            ),
          );
        } else {
          final products = snapshot.data;
          return ListView.builder(
            itemCount: products!.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  productProvider.productSizes = (product.sizes).cast<Map<String, dynamic>>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductPage(product: product)),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(8.h),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Container(
                      height: 100.h,
                      width: 325.w,
                      decoration: BoxDecoration(color: Colors.grey.shade100, boxShadow: [
                        BoxShadow(color: Colors.grey.shade500, spreadRadius: 5, blurRadius: 0.3, offset: const Offset(0, 1))
                      ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(12.h),
                                child: CachedNetworkImage(
                                  imageUrl: product.imageUrl[0],
                                  height: 70.h,
                                  width: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12.h, left: 10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ReusableText(
                                      text: product.name,
                                      style: appstyle(16, Colors.black, FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ReusableText(
                                      text: product.category,
                                      style: appstyle(14, Colors.grey, FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ReusableText(
                                      text: '\$${product.price}',
                                      style: appstyle(16, Colors.black, FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
