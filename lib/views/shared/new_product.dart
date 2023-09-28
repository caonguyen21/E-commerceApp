import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewProduct extends StatelessWidget {
  const NewProduct({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.h),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 1, blurRadius: 0.8, offset: Offset(0, 1))],
        ),
        height: 100.h,
        width: 104.w,
        child: Stack(
          children: [
            Center(
              child: CachedNetworkImage(imageUrl: imageUrl),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Transform.rotate(
                  angle: 30 * 3.141592653589793 / 180, // Convert degrees to radians
                  child: const Text(
                    'NEW',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
