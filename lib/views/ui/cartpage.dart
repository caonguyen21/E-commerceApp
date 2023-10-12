import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/models/cart/add_to_cart.dart';
import 'package:flutter_shopping_app/services/cart_helper.dart';
import 'package:flutter_shopping_app/views/shared/checkout_btn.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../controllers/login_provider.dart';
import '../../models/cart/get_products.dart';
import '../shared/appstyle.dart';
import '../shared/reusableText.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> cart = [];

  late Future<List<Product>> _cartList;

  @override
  void initState() {
    // TODO: implement initState
    _cartList = CartHelper().getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<LoginNotifier>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Cart",
                          style: appstyle(36, Colors.black, FontWeight.bold),
                        ),
                        FutureBuilder(
                            future: _cartList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return ReusableText(
                                  text: 'Total Item: 0',
                                  style: appstyle(18, Colors.black, FontWeight.w600),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: ReusableText(
                                    text: 'Total Item: 0',
                                    style: appstyle(18, Colors.black, FontWeight.w600),
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                return Text(
                                  "Total Item: ${snapshot.data?.length.toString()}",
                                  style: appstyle(18, Colors.black, FontWeight.w600),
                                );
                              } else {
                                return Text(
                                  'Total Item: 0',
                                  style: appstyle(18, Colors.black, FontWeight.w600),
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: FutureBuilder(
                        future: _cartList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: ReusableText(
                                text: 'No items in cart.',
                                style: appstyle(18, Colors.black, FontWeight.w600),
                              ),
                            );
                          } else if (snapshot.data == null || (snapshot.data as List).isEmpty) {
                            return Center(
                              child: Text(
                                'No items in cart.',
                                style: appstyle(28, Colors.black, FontWeight.bold),
                              ),
                            );
                          } else {
                            final cartData = snapshot.data;
                            return ListView.builder(
                                itemCount: cartData?.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  final data = cartData![index];
                                  //final totalPrice = cartProvider.calculateTotalPrice(data['price'], data['qty']);
                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.12,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(color: Colors.grey.shade100, boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade500, spreadRadius: 5, blurRadius: 0.3, offset: const Offset(0, 1))
                                        ]),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Stack(children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(12),
                                                    child: CachedNetworkImage(
                                                      imageUrl: data.cartItem.imageUrl[0],
                                                      width: 70,
                                                      height: 70,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Positioned(
                                                      bottom: -2,
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          await CartHelper().deleteItem(data.id).then((response) {
                                                            if (response == true) {
                                                              setState(() {
                                                                _cartList = CartHelper().getCart();
                                                              });
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 40.w,
                                                          height: 30.h,
                                                          decoration: const BoxDecoration(
                                                              color: Colors.black,
                                                              borderRadius: BorderRadius.only(topRight: Radius.circular(12))),
                                                          child: const Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ))
                                                ]),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 12, left: 20),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        data.cartItem.name,
                                                        style: appstyle(16, Colors.black, FontWeight.bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        data.cartItem.category,
                                                        style: appstyle(14, Colors.grey, FontWeight.w600),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(children: [
                                                        Text(
                                                          "\$${data.cartItem.price}",
                                                          style: appstyle(16, Colors.black, FontWeight.w600),
                                                        ),
                                                        const SizedBox(
                                                          width: 40,
                                                        ),
                                                        // Text(
                                                        //   "Size",
                                                        //   style: appstyle(16, Colors.grey, FontWeight.w600),
                                                        // ),
                                                        // const SizedBox(
                                                        //   width: 10,
                                                        // ),
                                                        // Text(
                                                        //   "${data['sizes']}".replaceAll('[', '').replaceAll(']', ''),
                                                        //   style: appstyle(16, Colors.grey, FontWeight.w600),
                                                        // ),
                                                      ])
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            if (data.quantity > 1) {
                                                              setState(() {
                                                                data.quantity = data.quantity - 1; // Decrement quantity
                                                              });
                                                              AddToCart model =
                                                                  AddToCart(cartItem: data.cartItem.id, quantity: data.quantity);
                                                              await CartHelper().addToCart(model, 'decrement');
                                                            }
                                                          },
                                                          child: const Icon(
                                                            FontAwesomeIcons.minusSquare,
                                                            size: 20,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        Text(
                                                          data.quantity.toString(),
                                                          style: appstyle(14, Colors.black, FontWeight.w600),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              data.quantity = data.quantity + 1; // Increment quantity
                                                            });
                                                            AddToCart model =
                                                                AddToCart(cartItem: data.cartItem.id, quantity: data.quantity);
                                                            CartHelper().addToCart(model, 'increment');
                                                          },
                                                          child: const Icon(
                                                            FontAwesomeIcons.plusSquare,
                                                            size: 20,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                        }),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CheckoutBtn(
                  label: 'Proceed to Checkout',
                ),
              )
            ],
          )),
    );
  }
}
