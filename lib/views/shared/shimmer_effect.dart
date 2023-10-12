import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerForLatest() {
  return StaggeredGridView.countBuilder(
    padding: EdgeInsets.zero,
    crossAxisCount: 2,
    crossAxisSpacing: 20.w,
    mainAxisSpacing: 16.h,
    scrollDirection: Axis.vertical,
    staggeredTileBuilder: (index) => StaggeredTile.extent(
      (index % 2 == 0) ? 1 : 1,
      (index % 4 == 1 || index % 4 == 3) ? 285.h : 270.h,
    ),
    itemBuilder: (context, index) {
      return Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Padding(
              padding: EdgeInsets.all(8.h),
              child: Shimmer.fromColors(
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
              )));
    },
  );
}

Widget shimmerForProductCard() {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) {
      return Padding(
        padding: EdgeInsets.fromLTRB(8.w, 0, 20.w, 0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          height: 325.h,
          width: 225.w,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Container(
                      height: 186.h,
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 40.h,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      Container(
                        width: double.infinity,
                        height: 20.h,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10.w,
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
          ),
        ),
      );
    },
  );
}

Widget shimmerForNewProduct() {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100.h,
          width: 104.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Stack(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    height: 38.h,
                    width: 56.w,
                  ),
                ),
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
    },
  );
}
