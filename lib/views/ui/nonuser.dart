import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/views/shared/reusableText.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../shared/appstyle.dart';
import 'auth/login.dart';

class NonUser extends StatelessWidget {
  const NonUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              height: 750.h,
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
                            ReusableText(
                                text: "Hello, Please Login into Your Account", style: appstyle(12, Colors.grey.shade600, FontWeight.normal))
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 50.w,
                            height: 30.h,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Center(
                              child: ReusableText(
                                text: 'Login',
                                style: appstyle(12, Colors.white, FontWeight.normal),
                              ),
                            ),
                          ),
                        )
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
