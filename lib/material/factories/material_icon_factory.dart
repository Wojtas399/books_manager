import 'package:flutter/material.dart';

import '../../interfaces/factories/icon_factory.dart';

class MaterialIconFactory implements IconFactory {
  final double defaultIconSize = 24;

  @override
  Icon createAccountIcon({double? size, Color? color}) {
    return Icon(
      Icons.person_outline_rounded,
      size: size ?? defaultIconSize,
      color: color,
    );
  }

  @override
  Icon createLockIcon({double? size, Color? color}) {
    return Icon(
      Icons.lock_outline_rounded,
      size: size ?? defaultIconSize,
      color: color,
    );
  }

  @override
  Icon createEnvelopeIcon({double? size, Color? color}) {
    return Icon(
      Icons.email_outlined,
      size: size ?? defaultIconSize,
      color: color,
    );
  }

  @override
  Icon createCloseIcon({double? size, Color? color}) {
    return Icon(
      Icons.close,
      size: size ?? defaultIconSize,
      color: color,
    );
  }

  @override
  Icon createBookIcon({double? size, Color? color}) {
    return Icon(
      Icons.library_books_outlined,
      size: size ?? defaultIconSize,
      color: color,
    );
  }

  @override
  Icon createImageIcon({double? size, Color? color}) {
    return Icon(
      Icons.image_outlined,
      size: size ?? defaultIconSize,
      color: color,
    );
  }

  @override
  Icon createCameraIcon({double? size, Color? color}) {
    return Icon(
      Icons.camera_alt_outlined,
      size: size ?? defaultIconSize,
      color: color,
    );
  }
}
