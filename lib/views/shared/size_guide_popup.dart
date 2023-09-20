import 'package:flutter/material.dart';

class ShoeSizeGuidePopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Shoe Size Guide',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ShoeSizeItem(size: 'US Size 7', length: 'Foot Length 9.25 inches'),
            ShoeSizeItem(size: 'US Size 7.5', length: 'Foot Length 9.375 inches'),
            ShoeSizeItem(size: 'US Size 8', length: 'Foot Length 9.5 inches'),
            ShoeSizeItem(size: 'US Size 8.5', length: 'Foot Length 9.625 inches'),
            // Add more shoe size information as needed
          ],
        ),
      ),
    );
  }
}

class ShoeSizeItem extends StatelessWidget {
  final String size;
  final String length;

  const ShoeSizeItem({required this.size, required this.length});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            size,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 8.0),
          Text(
            length,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}