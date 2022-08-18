import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../config/themes/app_colors.dart';
import '../models/avatar.dart';

class AvatarComponent extends StatelessWidget {
  final Avatar? avatar;
  final double size;
  final VoidCallback? onPressed;

  const AvatarComponent({
    super.key,
    required this.avatar,
    required this.size,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object>? imageProvider = _getImageProvider();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(
          color: AppColors.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ]),
      child: GestureDetector(
        onTap: onPressed,
        child: CircleAvatar(
          backgroundImage: imageProvider,
          backgroundColor: AppColors.white,
        ),
      ),
    );
  }

  ImageProvider<Object>? _getImageProvider() {
    final Avatar? avatar = this.avatar;
    if (avatar is UrlAvatar) {
      return CachedNetworkImageProvider(avatar.url);
    } else if (avatar is FileAvatar) {
      return FileImage(avatar.file);
    }
    return null;
  }
}