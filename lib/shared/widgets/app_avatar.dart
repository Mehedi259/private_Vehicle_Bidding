import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String fullName;
  final double radius;
  const AppAvatar({
    super.key,
    this.imageUrl,
    required this.fullName,
    this.radius = 30.0,
  });
  String getInitials(String name) {
    if (name.trim().isEmpty) return "?";
    List<String> nameParts = name.trim().split(RegExp(r'\s+'));
    if (nameParts.length > 1) {
      return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
    } else {
      return nameParts[0].length >= 2
          ? nameParts[0].substring(0, 2).toUpperCase()
          : nameParts[0][0].toUpperCase();
    }
  }
  Color getAvatarColor(String name) {
    final List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo
    ];
    int hash = name.hashCode;
    int index = hash.abs() % colors.length;
    return colors[index];
  }
  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
        return CachedNetworkImage(
          imageUrl: imageUrl!,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: radius,
            backgroundImage: imageProvider,
            backgroundColor: Colors.transparent,
          ),
          placeholder: (context, url) => SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey[200],
              child: Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: const Color(0xFF1B4E9F),
                  size: (radius * 0.5).r,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.broken_image, size: (radius * 0.8).r),
          ),
        );
      } else {
        ImageProvider imageProvider = imageUrl!.startsWith('assets/')
            ? AssetImage(imageUrl!)
            : FileImage(File(imageUrl!)) as ImageProvider;

        return CircleAvatar(
          radius: radius,
          backgroundImage: imageProvider,
          backgroundColor: Colors.transparent,
        );
      }
    }
    // Following figma, and telegram-style random colors
    return CircleAvatar(
      radius: radius,
      backgroundColor: getAvatarColor(fullName),
      child: Center(
        child: Text(
          getInitials(fullName),
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.65,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
