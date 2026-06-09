import 'package:flutter/material.dart';

class ImageUploadBox extends StatelessWidget {
  final VoidCallback onTap;

  const ImageUploadBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF6C3CE1), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 40,
              color: Color(0xFF6C3CE1),
            ),
            SizedBox(height: 8),
            Text(
              'Tap to upload image',
              style: TextStyle(
                color: Color(0xFF6C3CE1),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'JPG, PNG up to 5MB',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
