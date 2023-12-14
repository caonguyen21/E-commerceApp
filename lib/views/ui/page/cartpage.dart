import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/controllers/cart_provider.dart';
import 'package:flutter_shopping_app/controllers/payment_controller.dart';
import 'package:flutter_shopping_app/models/cart/add_to_cart.dart';
import 'package:flutter_shopping_app/services/cart_helper.dart';
import 'package:flutter_shopping_app/services/payment_helper.dart';
import 'package:flutter_shopping_app/views/shared/custom/checkout_btn.dart';
import 'package:flutter_shopping_app/views/ui/payments/payment_webview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/cart/get_products.dart';
import '../../../models/orders/orders_req.dart';
import '../../shared/appstyle.dart';
import '../../shared/reusableText.dart';

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
    var cartProvider = Provider.of<CartProvider>(context);
    var paymentNotifier = Provider.of<PaymentNotifier>(context);
    return paymentNotifier.paymentUrl.contains('https')
        ? const PaymentWebView()
        : Scaffold(
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
                          height: 500.h,
                          child: FutureBuilder(
                              future: _cartList,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Image.asset(
                                      "assets/images/cart.gif",
                                    ),
                                  );
                                } else if (snapshot.data == null || (snapshot.data as List).isEmpty) {
                                  return Center(
                                    child: Image.asset(
                                      "assets/images/cart.gif",
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
                                        return GestureDetector(
                                          onTap: () {
                                            cartProvider.toggleSelection(index);
                                            cartProvider.checkout.insert(0, data);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                                              child: Container(
                                                height: MediaQuery.of(context).size.height * 0.12,
                                                width: MediaQuery.of(context).size.width,
                                                decoration: BoxDecoration(color: Colors.grey.shade100, boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey.shade500,
                                                      spreadRadius: 5,
                                                      blurRadius: 0.3,
                                                      offset: const Offset(0, 1))
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
                                                            top: -4,
                                                            child: GestureDetector(
                                                              onTap: () {},
                                                              child: SizedBox(
                                                                height: 30.h,
                                                                width: 30.w,
                                                                child: Icon(
                                                                  cartProvider.selectedIndices.contains(index)
                                                                      ? Icons.check_box_outlined
                                                                      : Icons.check_box_outline_blank_outlined,
                                                                  color: Colors.black,
                                                                  size: 20,
                                                                ),
                                                              ),
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
                                                                SizedBox(
                                                                  width: 40.w,
                                                                ),
                                                                Text(
                                                                  "Size: ",
                                                                  style: appstyle(16, Colors.grey, FontWeight.w600),
                                                                ),
                                                                Text(
                                                                  data.size,
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
                                                                  onTap: () async {
                                                                    if (data.quantity > 1) {
                                                                      setState(() {
                                                                        data.quantity = data.quantity - 1; // Decrement quantity
                                                                      });
                                                                      AddToCart model = AddToCart(
                                                                          cartItem: data.cartItem.id, quantity: data.quantity, size: '');
                                                                      await CartHelper().addToCart(model, 'decrement', "");
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
                                                                    AddToCart model = AddToCart(
                                                                        cartItem: data.cartItem.id, quantity: data.quantity, size: '');
                                                                    CartHelper().addToCart(model, 'increment', "");
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
                                      });
                                }
                              }),
                        )
                      ],
                    ),
                    cartProvider.selectedIndices.isNotEmpty
                        ? Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, -3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10.w, 0, 20.w, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total price:",
                                          style: appstyle(18, Colors.black, FontWeight.bold),
                                        ),
                                        FutureBuilder<List<Product>>(
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
                                            } else if (snapshot.data == null) {
                                              return Center(
                                                child: Text(
                                                  'No items in cart.',
                                                  style: appstyle(28, Colors.black, FontWeight.bold),
                                                ),
                                              );
                                            } else {
                                              // Retrieve the cart data from the snapshot
                                              List<Product>? cartData = snapshot.data;

                                              // Calculate the total price using the cartData
                                              double totalPrice = cartProvider.calculateTotalPrice(cartData!);

                                              return Text(
                                                "\$${totalPrice}0",
                                                style: appstyle(18, Colors.black, FontWeight.w600),
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  CheckoutBtn(
                                    onTap: () async {
                                      // Get user ID from SharedPreferences
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      String? userId = prefs.getString('userId') ?? "";

                                      // Create an instance of the Order class
                                      Order model = Order(
                                        userId: userId,
                                        cartItems: [
                                          CartItem(
                                            name: cartProvider.checkout[0].cartItem.name,
                                            id: cartProvider.checkout[0].cartItem.id,
                                            price: cartProvider.checkout[0].cartItem.price,
                                            cartQuantity: cartProvider.checkout[0].quantity,
                                          )
                                        ],
                                      );

                                      // Make the payment
                                      PaymentHelper().payment(model).then((value) {
                                        paymentNotifier.setPaymentUrl = value;
                                      });
                                    },
                                    label: 'Proceed to Checkout',
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                )),
          );
  }
}
