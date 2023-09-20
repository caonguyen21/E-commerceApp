import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewProduct extends StatelessWidget {
  const NewProduct({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 1, blurRadius: 0.8, offset: Offset(0, 1))],
        ),
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.width * 0.28,
        child: Stack(
          children: [
            Center(
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(15 / 360),
                child: CachedNetworkImage(imageUrl: imageUrl),
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
  }
}
