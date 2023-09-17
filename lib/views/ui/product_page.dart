import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_shopping_app/controllers/product_provider.dart';
import 'package:flutter_shopping_app/services/helper.dart';
import 'package:flutter_shopping_app/views/shared/appstyle.dart';
import 'package:flutter_shopping_app/views/ui/mainscreen.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../controllers/constants.dart';
import '../../models/product.dart';
import '../shared/checkout_btn.dart';
import 'favoritepage.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.id, required this.catogory});

  final String id;
  final String catogory;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PageController pageController = PageController();
  late Future<Product> _product;
  final _cartBox = Hive.box('cart_box');
  final _favBox = Hive.box("fav_box");

  Future<void> _createFav(Map<String, dynamic> addFav) async {
    await _favBox.add(addFav);
    getFavorites();
  }

  getFavorites() {
    final favData = _favBox.keys.map((key) {
      final item = _favBox.get(key);
      return {"key": key, "id": item['id']};
    }).toList();
    favor = favData.toList();
    ids = favor.map((item) => item['id']).toList();
    setState(() {});
  }

  void getProduct() {
    if (widget.catogory == "Men's Running") {
      _product = Helper().getMaleProductsById(widget.id);
    } else if (widget.catogory == "Women's Running") {
      _product = Helper().getFemaleProductsById(widget.id);
    } else {
      _product = Helper().getMaleProductsById(widget.id);
    }
    _product.catchError((error) {
      // Handle errors here, e.g., show an error message to the user.
      if (kDebugMode) {
        print('Error fetching product: $error');
      }
    });
  }

  Future<void> _createCart(Map<String, dynamic> newCart) async {
    await _cartBox.add(newCart);
    // print(newCart);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Product>(
          future: _product,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error ${snapshot.error}");
            } else {
              final product = snapshot.data;
              return Consumer<ProductNotifier>(
                builder: (context, productNotifier, child) {
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        leadingWidth: 0,
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (ids.contains(widget.id)) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritePage()));
                                  } else {
                                    _createFav({
                                      "id": product?.id ?? '',
                                      "name": product?.name ?? '',
                                      "category": product?.category ?? '',
                                      "price": product?.price ?? 0.0,
                                      "imageUrl": product?.imageUrl?.isNotEmpty == true ? product?.imageUrl![0] : ''
                                    });
                                  }
                                },
                                child: ids.contains(widget.id)
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.black,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        color: Colors.black,
                                      ),
                              )
                            ],
                          ),
                        ),
                        pinned: true,
                        snap: false,
                        floating: true,
                        backgroundColor: Colors.transparent,
                        expandedHeight: MediaQuery.of(context).size.height,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.width,
                                child: PageView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: product!.imageUrl.length,
                                    controller: pageController,
                                    onPageChanged: (page) {
                                      productNotifier.activePage = page;
                                    },
                                    itemBuilder: (context, int index) {
                                      return Stack(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height * 0.39,
                                            width: MediaQuery.of(context).size.width,
                                            color: Colors.grey.shade300,
                                            child: CachedNetworkImage(
                                              imageUrl: product.imageUrl[index],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          // Positioned(
                                          //   top: MediaQuery.of(context).size.height * 0.1,
                                          //   right: 20,
                                          //   child: const Icon(
                                          //     FontAwesomeIcons.heart,
                                          //     color: Colors.grey,
                                          //   ),
                                          // ),
                                          Positioned(
                                              bottom: 0,
                                              right: 0,
                                              left: 0,
                                              height: MediaQuery.of(context).size.height * 0.3,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: List<Widget>.generate(
                                                  product.imageUrl.length,
                                                  (index) => Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                                    child: CircleAvatar(
                                                      radius: 5,
                                                      backgroundColor: productNotifier.activepage != index ? Colors.grey : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      );
                                    }),
                              ),
                              Positioned(
                                bottom: 10,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.645,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: appstyle(40, Colors.black, FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                product.name,
                                                style: appstyle(20, Colors.grey, FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              RatingBar.builder(
                                                initialRating: 4,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 22,
                                                itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                                                itemBuilder: (context, _) => const Icon(Icons.star, size: 18, color: Colors.black),
                                                onRatingUpdate: (rating) {
                                                  // You can add your code here to handle the updated rating.
                                                  // print("New Rating: $rating");
                                                  // You might want to update some state variables or perform other actions.
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "\$${product.price}",
                                                style: appstyle(26, Colors.black, FontWeight.w600),
                                              ),
                                              // Row(
                                              //   children: [
                                              //     Text(
                                              //       "Colors",
                                              //       style: appstyle(
                                              //           18,
                                              //           Colors.black,
                                              //           FontWeight.w500),
                                              //     ),
                                              //     SizedBox(
                                              //       width: 5,
                                              //     ),
                                              //     CircleAvatar(
                                              //       radius: 7,
                                              //       backgroundColor:
                                              //           Colors.black,
                                              //     ),
                                              //     SizedBox(
                                              //       width: 5,
                                              //     ),
                                              //     CircleAvatar(
                                              //       radius: 7,
                                              //       backgroundColor: Colors.red,
                                              //     )
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Select sizes",
                                                    style: appstyle(20, Colors.black, FontWeight.w600),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    "View size guide",
                                                    style: appstyle(20, Colors.grey, FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                height: 40,
                                                child: ListView.builder(
                                                  itemCount: productNotifier.productSizes.length,
                                                  scrollDirection: Axis.horizontal,
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder: (context, index) {
                                                    final sizes = productNotifier.productSizes[index];
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                      child: ChoiceChip(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(60),
                                                            side: const BorderSide(
                                                              color: Colors.black,
                                                              width: 1,
                                                              style: BorderStyle.solid,
                                                            ),
                                                          ),
                                                          disabledColor: Colors.white,
                                                          label: Text(
                                                            sizes['size'],
                                                            // Assuming 'size' is a key in the map
                                                            style: appstyle(
                                                              18,
                                                              sizes['isSelected'] ? Colors.white : Colors.black,
                                                              FontWeight.w500,
                                                            ),
                                                          ),
                                                          selectedColor: Colors.black,
                                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                                          selected: sizes['isSelected'],
                                                          onSelected: (newState) {
                                                            final selectedSize = sizes['size'];
                                                            setState(() {
                                                              if (productNotifier.sizes.contains(selectedSize)) {
                                                                productNotifier.sizes.remove(selectedSize);
                                                              } else {
                                                                productNotifier.sizes.add(selectedSize);
                                                              }
                                                              productNotifier.toggleCheck(index); // Call toggleCheck with the index
                                                            });
                                                          }),
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Divider(
                                            indent: 10,
                                            endIndent: 10,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.8,
                                            child: Text(
                                              product.title,
                                              style: appstyle(22, Colors.black, FontWeight.w700),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            product.description,
                                            style: appstyle(14, Colors.black, FontWeight.normal),
                                            textAlign: TextAlign.justify,
                                            maxLines: 4,
                                          ),
                                          Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 10),
                                                child: CheckoutBtn(
                                                  onTap: () {
                                                    // Ensure sizes is not null and contains data
                                                    if (productNotifier.sizes != null && productNotifier.sizes.isNotEmpty) {
                                                      _createCart({
                                                        "id": product.id,
                                                        "name": product.name,
                                                        "category": product.category,
                                                        "sizes": List.from(productNotifier.sizes), // Create a copy of sizes
                                                        "imageUrl": product.imageUrl[0],
                                                        "price": product.price,
                                                        "qty": 1
                                                      });

                                                      // Clear sizes in the productNotifier
                                                      productNotifier.sizes.clear();

                                                      // Pop the current screen
                                                      Navigator.pop(context);
                                                    } else {
                                                      // Handle the case where sizes is empty or null
                                                      // You might want to show a message to the user or take appropriate action.
                                                      print('Sizes data is empty or null.');
                                                    }
                                                  },
                                                  label: 'Add to bag',
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            }
          }),
    );
  }
}
