import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_shopping_app/controllers/product_provider.dart';
import 'package:flutter_shopping_app/services/helper.dart';
import 'package:flutter_shopping_app/views/shared/appstyle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';

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
      print('Error fetching product: $error');
    });
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
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  // productNotifier.productSizes.clear();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: null,
                                child: Icon(
                                  FontAwesomeIcons.ellipsis,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.39,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.grey.shade300,
                                            child: CachedNetworkImage(
                                              imageUrl: product.imageUrl[index],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Positioned(
                                            child: Icon(
                                              FontAwesomeIcons.heart,
                                              color: Colors.grey,
                                            ),
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            right: 20,
                                          ),
                                          Positioned(
                                              bottom: 0,
                                              right: 0,
                                              left: 0,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: List<Widget>.generate(
                                                  product.imageUrl.length,
                                                  (index) => Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4),
                                                    child: CircleAvatar(
                                                      radius: 5,
                                                      backgroundColor:
                                                          productNotifier
                                                                      .activepage !=
                                                                  index
                                                              ? Colors.grey
                                                              : Colors.black,
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
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.645,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: appstyle(40, Colors.black,
                                                FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                product.name,
                                                style: appstyle(20, Colors.grey,
                                                    FontWeight.w500),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              RatingBar.builder(
                                                initialRating: 4,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 22,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 1),
                                                itemBuilder: (context, _) =>
                                                    Icon(Icons.star,
                                                        size: 18,
                                                        color: Colors.black),
                                                onRatingUpdate: (rating) {
                                                  // You can add your code here to handle the updated rating.
                                                  print("New Rating: $rating");
                                                  // You might want to update some state variables or perform other actions.
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "\$${product.price}",
                                                style: appstyle(
                                                    26,
                                                    Colors.black,
                                                    FontWeight.w600),
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
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Select sizes",
                                                    style: appstyle(
                                                        20,
                                                        Colors.black,
                                                        FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    "View size guide",
                                                    style: appstyle(
                                                        20,
                                                        Colors.grey,
                                                        FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                height: 40,
                                                child: ListView.builder(
                                                  itemCount: productNotifier
                                                      .productSizes.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final sizes =
                                                        productNotifier
                                                                .productSizes[
                                                            index];
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.0),
                                                      child: ChoiceChip(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(60),
                                                          side: BorderSide(
                                                            color: Colors.black,
                                                            width: 1,
                                                            style: BorderStyle
                                                                .solid,
                                                          ),
                                                        ),
                                                        disabledColor:
                                                            Colors.white,
                                                        label: Text(
                                                          sizes['size'],
                                                          // Assuming 'size' is a key in the map
                                                          style: appstyle(
                                                            18,
                                                            sizes['isSelected']
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                        selectedColor:
                                                            Colors.black,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8),
                                                        selected:
                                                            sizes['isSelected'],
                                                        onSelected: (newState) {
                                                          setState(() {
                                                            productNotifier
                                                                .toggleCheck(
                                                                    index);
                                                          }); // Call toggleCheck with the index
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          )
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
