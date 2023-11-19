import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/services/auth_helper.dart';
import 'package:flutter_shopping_app/views/shared/tiles_widget.dart';
import 'package:flutter_shopping_app/views/ui/NonUser.dart';
import 'package:flutter_shopping_app/views/ui/auth/login.dart';
import 'package:flutter_shopping_app/views/ui/favoritepage.dart';
import 'package:flutter_shopping_app/views/ui/orders/orders.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../controllers/login_provider.dart';
import '../shared/appstyle.dart';
import '../shared/reusableText.dart';
import 'cartpage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<LoginNotifier>(context);
    return authNotifier.login == false
        ? const NonUser()
        : Scaffold(
            backgroundColor: const Color(0xFFE2E2E2),
            appBar: AppBar(
              backgroundColor: const Color(0xFFE2E2E2),
              elevation: 0,
              leading: const Icon(
                Icons.qr_code_scanner,
                size: 18,
                color: Colors.black,
              ),
              actions: [
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/usa.svg',
                          width: 25.w,
                          height: 25.h,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Container(
                          height: 15.h,
                          width: 1.w,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        ReusableText(text: "USA", style: appstyle(16, Colors.black, FontWeight.normal)),
                        SizedBox(
                          width: 10.w,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Icon(
                            Icons.settings_outlined,
                            color: Colors.black,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 70.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2E2E2),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child: const CircleAvatar(
                                      backgroundImage: AssetImage('assets/images/user.jpeg'),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  FutureBuilder(
                                      future: AuthHelper().getProfile(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator.adaptive(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: ReusableText(
                                              text: "Error get your data",
                                              style: appstyle(18, Colors.black, FontWeight.w600),
                                            ),
                                          );
                                        } else {
                                          final userData = snapshot.data;
                                          return SizedBox(
                                            height: 40.h,
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              ReusableText(
                                                  text: userData?.username ?? "UserName",
                                                  style: appstyle(12, Colors.black, FontWeight.normal)),
                                              ReusableText(
                                                  text: userData?.email ?? "email.com",
                                                  style: appstyle(12, Colors.black, FontWeight.normal)),
                                            ]),
                                          );
                                        }
                                      })
                                ],
                              ),
                              GestureDetector(
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color(0xFFE2E2E2),
                    height: 600.h,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          height: 175.h,
                          color: Colors.grey.shade200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TilesWidget(
                                title: "My Orders",
                                leading: Icons.delivery_dining_outlined,
                                OnTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProcessOrders()));
                                },
                              ),
                              TilesWidget(
                                title: "My Favorites",
                                leading: Icons.favorite_outline,
                                OnTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritePage()));
                                },
                              ),
                              TilesWidget(
                                title: "Cart",
                                leading: Icons.shopping_bag_outlined,
                                OnTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          height: 120.h,
                          color: Colors.grey.shade200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showComingSoonDialog(context, "Coupons"); // Pass the title to the function
                                },
                                child: const TilesWidget(title: "Coupons", leading: Icons.tag_outlined),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showComingSoonDialog(context, "My Store"); // Pass the title to the function
                                },
                                child: const TilesWidget(title: "My Store", leading: Icons.store_outlined),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          height: 175.h,
                          color: Colors.grey.shade200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showComingSoonDialog(context, "Shipping addresses"); // Pass the title to the function
                                },
                                child: const TilesWidget(title: "Shipping addresses", leading: Icons.location_on_outlined),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showComingSoonDialog(context, "Settings"); // Pass the title to the function
                                },
                                child: const TilesWidget(title: "Settings", leading: Icons.settings_outlined),
                              ),
                              TilesWidget(
                                  OnTap: () {
                                    authNotifier.logout();
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                                  },
                                  title: "Logout",
                                  leading: Icons.logout_outlined)
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

Future<void> showComingSoonDialog(BuildContext context, String title) async {
  await Future.delayed(const Duration(seconds: 1));

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('The $title feature is coming soon!'), // Use the title in the dialog
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
