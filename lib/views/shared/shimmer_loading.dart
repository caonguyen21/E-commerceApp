import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150.w,
            height: 150.h,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
          Container(
            padding: EdgeInsets.only(top: 12.h),
            height: 75.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20.h,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: double.infinity,
                  height: 20.h,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
