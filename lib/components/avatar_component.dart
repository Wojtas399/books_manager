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
      height: size,
      width: size,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: imageProvider != null
            ? Image(image: imageProvider)
            : Container(color: AppColors.white),
      ),
    );
  }

  ImageProvider<Object>? _getImageProvider() {
    final Avatar? avatar = this.avatar;
    if (avatar is UrlAvatar) {
      return CachedNetworkImageProvider(avatar.url);
    } else if (avatar is FileAvatar) {
      return FileImage(avatar.file);
    } else if (avatar is BasicAvatar) {
      return AssetImage(avatar.type.toAssetsPath());
    }
    return null;
  }
}
