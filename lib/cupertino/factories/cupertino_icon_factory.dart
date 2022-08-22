import 'package:flutter/cupertino.dart';

import '../../interfaces/factories/icon_factory_interface.dart';

class CupertinoIconFactory implements IconFactoryInterface {
  final double defaultIconSize = 24;

  @override
  Icon createAccountIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.person,
      size: size ?? defaultIconSize,
      color: color,
    );
  }

  @override
  Icon createLockIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.lock,
      size: size ?? defaultIconSize,
      color: color,
    );
  }

  @override
  Icon createEnvelopeIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.envelope,
      size: size ?? defaultIconSize,
      color: color,
    );
  }

  @override
  Icon createCloseIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.clear,
      size: size ?? defaultIconSize,
      color: color,
    );
  }

  @override
  Icon createBookIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.book,
      size: size ?? defaultIconSize,
      color: color,
    );
  }

  @override
  Icon createImageIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.photo,
      size: size ?? defaultIconSize,
      color: color,
    );
  }

  @override
  Icon createCameraIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.camera,
      size: size ?? defaultIconSize,
      color: color,
    );
  }
}
