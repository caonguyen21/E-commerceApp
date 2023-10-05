import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/controllers/cart_provider.dart';
import 'package:flutter_shopping_app/views/shared/checkout_btn.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../shared/appstyle.dart';
import 'mainscreen.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    cartProvider.loadCartData();
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
                    onTap: () {},
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "My Cart",
                    style: appstyle(36, Colors.black, FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: cartProvider.cart.isEmpty
                        ? Center(
                            child: Text(
                              'No items in cart.',
                              style: appstyle(28, Colors.black, FontWeight.bold),
                            ),
                          )
                        : ListView.builder(
                            itemCount: cartProvider.cart.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final data = cartProvider.cart[index];
                              final totalPrice = cartProvider.calculateTotalPrice(data['price'], data['qty']);
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                                  child: Slidable(
                                    key: const ValueKey(0),
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          flex: 1,
                                          backgroundColor: const Color(0xFF000000),
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          onPressed: (context) {
                                            cartProvider.deleteCart(data['key']);
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
                                          },
                                          label: 'Delete',
                                        )
                                      ],
                                    ),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.12,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(color: Colors.grey.shade100, boxShadow: [
                                        BoxShadow(color: Colors.grey.shade500, spreadRadius: 5, blurRadius: 0.3, offset: const Offset(0, 1))
                                      ]),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: CachedNetworkImage(
                                                  imageUrl: data['imageUrl'],
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 12, left: 20),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data['name'],
                                                      style: appstyle(16, Colors.black, FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      data['category'],
                                                      style: appstyle(14, Colors.grey, FontWeight.w600),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(children: [
                                                      Text(
                                                        totalPrice,
                                                        style: appstyle(16, Colors.black, FontWeight.w600),
                                                      ),
                                                      const SizedBox(
                                                        width: 40,
                                                      ),
                                                      Text(
                                                        "Size",
                                                        style: appstyle(16, Colors.grey, FontWeight.w600),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "${data['sizes']}".replaceAll('[', '').replaceAll(']', ''),
                                                        style: appstyle(16, Colors.grey, FontWeight.w600),
                                                      ),
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
                                                        onTap: () {
                                                          cartProvider.decrementQuantity(index);
                                                        },
                                                        child: const Icon(
                                                          FontAwesomeIcons.minusSquare,
                                                          size: 20,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Text(
                                                        data['qty'].toString(),
                                                        style: appstyle(14, Colors.black, FontWeight.w600),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          cartProvider.incrementQuantity(index);
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
                                ),
                              );
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
