import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/controllers/cart_provider.dart';
import 'package:flutter_shopping_app/controllers/favorites_provider.dart';
import 'package:flutter_shopping_app/controllers/product_provider.dart';
import 'package:flutter_shopping_app/views/shared/appstyle.dart';
import 'package:flutter_shopping_app/views/shared/reusableText.dart';
import 'package:flutter_shopping_app/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../models/product.dart';
import '../shared/checkout_btn.dart';
import '../shared/size_guide_popup.dart';
import 'favoritepage.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PageController pageController = PageController();
  late ProductNotifier productNotifier;
  bool isDescriptionExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productNotifier = Provider.of<ProductNotifier>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var favoritesNotifier = Provider.of<FavoritesNotifier>(context);
    var cartProvider = Provider.of<CartProvider>(context);
    favoritesNotifier.getFavorites();
    return Scaffold(
      body: Consumer<ProductNotifier>(
        builder: (context, productNotifier, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                leadingWidth: 0,
                title: Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
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
                      Consumer<FavoritesNotifier>(builder: (context, favoritesNotifier, child) {
                        return GestureDetector(
                          onTap: () {
                            if (favoritesNotifier.ids.contains(widget.product.id)) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritePage()));
                            } else {
                              favoritesNotifier.createFav({
                                "id": widget.product.id,
                                "name": widget.product.name,
                                "category": widget.product.category,
                                "price": widget.product.price,
                                "imageUrl": widget.product.imageUrl[0]
                              });
                              setState(() {});
                            }
                          },
                          child: favoritesNotifier.ids.contains(widget.product.id)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                ),
                        );
                      })
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
                        height: 401.h,
                        width: 375.w,
                        child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.product.imageUrl.length,
                            controller: pageController,
                            onPageChanged: (page) {
                              productNotifier.activePage = page;
                            },
                            itemBuilder: (context, int index) {
                              return Stack(
                                children: [
                                  Container(
                                    height: 316.h,
                                    width: 375.w,
                                    color: Colors.grey.shade300,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.product.imageUrl[index],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List<Widget>.generate(
                                          widget.product.imageUrl.length,
                                          (index) => Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4.h),
                                            child: CircleAvatar(
                                              radius: 5,
                                              backgroundColor: productNotifier.activePage != index ? Colors.grey : Colors.black,
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
                            width: 375.w,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReusableText(
                                    text: widget.product.name,
                                    style: appstyle(40, Colors.black, FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 210.w,
                                        child: ReusableText(
                                          text: widget.product.name,
                                          style: appstyle(20, Colors.grey, FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      RatingBar.builder(
                                        initialRating: 4,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 22,
                                        itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                                        itemBuilder: (context, _) => Icon(Icons.star, size: 18.h, color: Colors.black),
                                        onRatingUpdate: (rating) {
                                          // You can add your code here to handle the updated rating.
                                          // print("New Rating: $rating");
                                          // You might want to update some state variables or perform other actions.
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\$${widget.product.price}",
                                        style: appstyle(26, Colors.black, FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          ReusableText(
                                            text: "Select sizes",
                                            style: appstyle(20, Colors.black, FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return ShoeSizeGuidePopup();
                                                },
                                              );
                                            },
                                            child: ReusableText(
                                              text: "View Size Guide",
                                              style: appstyle(20, Colors.grey, FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      SizedBox(
                                        height: 40.h,
                                        child: ListView.builder(
                                          itemCount: productNotifier.productSizes.length,
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            final sizes = productNotifier.productSizes[index];
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: ChoiceChip(
                                                  disabledColor: Colors.white,
                                                  label: Text(
                                                    sizes['size'],
                                                    // Assuming 'size' is a key in the map
                                                    style: appstyle(
                                                      16,
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
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        widget.product.title,
                                        style: appstyle(22, Colors.black, FontWeight.w700),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SingleChildScrollView(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                    ReadMoreText(
                                      widget.product.description,
                                      trimLines: 4,
                                      style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
                                      colorClickableText: Colors.blue,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '...Read more',
                                      trimExpandedText: ' Less',
                                    ),
                                  ])),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: CheckoutBtn(
          onTap: () {
            // Ensure sizes is not null and contains data
            if (productNotifier.sizes.isNotEmpty) {
              cartProvider.createCart({
                "id": widget.product.id,
                "name": widget.product.name,
                "category": widget.product.category,
                "sizes": List.from(productNotifier.sizes), // Create a copy of sizes
                "imageUrl": widget.product.imageUrl[0],
                "price": widget.product.price,
                "qty": 1
              });
              // Clear sizes in the productNotifier
              productNotifier.sizes.clear();

              // Pop the current screen
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No sizes available for this product.'),
                ),
              );
            }
          },
          label: 'Add to bag',
        ),
      ),
    );
  }
}
