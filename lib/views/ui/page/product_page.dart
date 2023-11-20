import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/controllers/login_provider.dart';
import 'package:flutter_shopping_app/controllers/product_provider.dart';
import 'package:flutter_shopping_app/models/cart/add_to_cart.dart';
import 'package:flutter_shopping_app/services/cart_helper.dart';
import 'package:flutter_shopping_app/views/shared/appstyle.dart';
import 'package:flutter_shopping_app/views/ui/page/cartpage.dart';
import 'package:flutter_shopping_app/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../../models/cart/get_products.dart';
import '../../../models/favorite/add_to_fav.dart';
import '../../../models/favorite/get_productsfav.dart';
import '../../../models/product.dart';
import '../../../services/fav_helper.dart';
import '../../shared/custom/checkout_btn.dart';
import '../../shared/reusableText.dart';
import '../../shared/widget/size_guide_popup.dart';
import '../auth/nonuser.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.product});

  final Products product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PageController pageController = PageController();
  late ProductNotifier productNotifier;
  late Future<List<Product>> _cartList;
  late bool isProductFavorite;
  bool _isMounted = false;

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> loadFavorites() async {
    try {
      List<ProductFav> favorites = await FavoriteHelper().getFavorites();
      if (_isMounted) {
        setState(() {
          isProductFavorite = favorites.any((fav) => fav.favItem.id == widget.product.id);
        });
      }
    } catch (e) {
      // Handle errors
    }
  }

  Future<void> toggleFavorite() async {
    try {
      if (isProductFavorite) {
        await FavoriteHelper().deleteFavorite(widget.product.id);
      } else {
        await FavoriteHelper().addFavorite(Favorite(productId: widget.product.id));
      }
      setState(() {
        isProductFavorite = !isProductFavorite; // Toggle the favorite status
      });
    } catch (e) {
      // Handle errors
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _cartList = CartHelper().getCart();
    productNotifier = Provider.of<ProductNotifier>(context, listen: false);
    _isMounted = true;
    isProductFavorite = false; // Initialize to false
    loadFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<LoginNotifier>(context);
    String selectedSize = productNotifier.getSelectedSize();
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: Consumer<ProductNotifier>(
        builder: (context, productNotifier, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                title: Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
                            },
                            child: Stack(
                              children: [
                                const Icon(
                                  Icons.shopping_cart,
                                  color: Colors.black,
                                ),
                                Positioned(
                                  right: 0,
                                  top: -5,
                                  child: Container(
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: FutureBuilder(
                                      future: _cartList,
                                      builder: (context, snapshot) {
                                        final itemCount = snapshot.connectionState == ConnectionState.done ? snapshot.data?.length : 0;
                                        return Text(
                                          itemCount?.toString() ?? '0',
                                          style: appstyle(12.sp, Colors.white, FontWeight.bold),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (authNotifier.login == true) {
                                await toggleFavorite();
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const NonUser()));
                              }
                            },
                            child: Icon(
                              isProductFavorite ? Icons.favorite : Icons.favorite_outline,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.transparent,
                expandedHeight: 275.h,
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
                                      bottom: 30,
                                      right: 0,
                                      left: 0,
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
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: widget.product.name,
                            style: appstyle(40.sp, Colors.black, FontWeight.bold),
                          ),
                          ReusableText(
                            text: widget.product.category,
                            style: appstyle(20.sp, Colors.grey, FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${widget.product.price}",
                                style: appstyle(26.sp, Colors.black, FontWeight.w600),
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
                                    style: appstyle(20.sp, Colors.black, FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const ShoeSizeGuidePopup();
                                        },
                                      );
                                    },
                                    child: ReusableText(
                                      text: "View Size Guide",
                                      style: appstyle(20.sp, Colors.grey, FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
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
                                          sizes['size'], // Assuming 'size' is a key in the map
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: sizes['isSelected'] ? Colors.white : Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        selectedColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        selected: sizes['isSelected'],
                                        onSelected: (newState) {
                                          setState(() {
                                            // Deselect previously selected size
                                            for (var i = 0; i < productNotifier.productSizes.length; i++) {
                                              if (i != index) {
                                                productNotifier.productSizes[i]['isSelected'] = false;
                                              }
                                            }

                                            sizes['isSelected'] = newState;
                                          });

                                          // Print the selected size
                                        },
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          const Divider(
                            indent: 10,
                            endIndent: 10,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                widget.product.title,
                                style: appstyle(22.sp, Colors.black, FontWeight.w700),
                              )),
                          SizedBox(
                            height: 10.h,
                          ),
                          ReadMoreText(
                            widget.product.description,
                            trimLines: 5,
                            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
                            colorClickableText: Colors.blue,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '...Read more',
                            trimExpandedText: ' Less',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: CheckoutBtn(
            onTap: () {
              if (authNotifier.login == true) {
                // Check if product sizes are available
                if (selectedSize.isNotEmpty) {
                  AddToCart model = AddToCart(cartItem: widget.product.id, quantity: 1, size: selectedSize);
                  CartHelper().addToCart(model, 'increment', selectedSize).then((success) {
                    if (success) {
                      setState(() {
                        _cartList = CartHelper().getCart();
                        productNotifier.clearSelectedSizes();
                      });
                    }
                  });
                  _showSuccessDialog(context);
                } else {
                  // Show a snackbar indicating no sizes available
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No sizes available for this product.'),
                    ),
                  );
                }
              } else {
                // Navigate to a non-user page
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NonUser()));
              }
            },
            label: 'Add to bag',
          ),
        ),
      ),
    );
  }
}

void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.white,
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48.0,
              ),
              SizedBox(height: 16.0),
              Text(
                'Success! Added to cart',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  Future.delayed(const Duration(seconds: 1), () {
    Navigator.of(context).pop();
  });
}
