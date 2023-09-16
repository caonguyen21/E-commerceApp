import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/views/shared/checkout_btn.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

import '../shared/appstyle.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _cartBox = Hive.box('cart_box');
  List<Map<String, dynamic>> cartData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCartData();
  }

  void _loadCartData() {
    setState(() {
      cartData = _cartBox.keys.map((key) {
        final item = _cartBox.get(key);
        return {
          "key": key,
          "id": item['id'],
          "category": item['category'],
          "name": item['name'],
          "price": item['price'],
          "qty": item['qty'],
          "sizes": item['sizes'],
          "imageUrl": item['imageUrl'],
        };
      }).toList();
    });
  }

  void deleteCartItem(int index) {
    setState(() {
      // Remove the item from the cartData list
      cartData.removeAt(index);

      // Remove the item from the Hive box
      final itemKey = _cartBox.keyAt(index);
      _cartBox.delete(itemKey);
    });
  }

  void incrementQuantity(int index) {
    setState(() {
      cartData[index]['qty']++;
      updateCartItem(index);
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (cartData[index]['qty'] > 1) {
        cartData[index]['qty']--;
        updateCartItem(index);
      }
    });
  }

  String multiplyPriceByQuantity(String price, int qty) {
    // Remove any leading '$' and convert the price string to a double
    double priceNumeric = double.parse(price.replaceAll('\$', ''));

    // Multiply by the quantity
    double totalPrice = priceNumeric * qty;

    // Format the result to display with 2 decimal places
    String formattedTotalPrice = totalPrice.toStringAsFixed(2);

    return '\$$formattedTotalPrice'; // Add '$' and display with .00
  }

  void updateCartItem(int index) {
    String priceString = cartData[index]['price'];
    int quantity = cartData[index]['qty'];

    // Calculate the total price based on quantity
    String totalPrice = multiplyPriceByQuantity(priceString, quantity);

    cartData[index]['totalPrice'] = totalPrice;

    final itemKey = cartData[index]['key'];
    _cartBox.put(itemKey, cartData[index]);
  }

  @override
  Widget build(BuildContext context) {
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
                    child: ListView.builder(
                        itemCount: cartData.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final data = cartData[index];
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
                                        deleteCartItem(index);
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
                                                  style: appstyle(16, Colors.grey, FontWeight.w600),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(children: [
                                                  Text(
                                                    '${cartData[index]['totalPrice'] ?? '\$${data['price']}'}',
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
                                                      decrementQuantity(index);
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
                                                      incrementQuantity(index);
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
