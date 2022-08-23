import 'package:flutter/cupertino.dart';

import '../../interfaces/factories/icon_factory.dart';

class CupertinoIconFactory implements IconFactory {
  @override
  Icon createAccountIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.person,
      size: size,
      color: color,
    );
  }

  @override
  Icon createLockIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.lock,
      size: size,
      color: color,
    );
  }

  @override
  Icon createEnvelopeIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.envelope,
      size: size,
      color: color,
    );
  }

  @override
  Icon createCloseIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.clear,
      size: size,
      color: color,
    );
  }

  @override
  Icon createBookIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.book,
      size: size,
      color: color,
    );
  }

  @override
  Icon createLibraryIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.collections,
      size: size,
      color: color,
    );
  }

  @override
  Icon createImageIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.photo,
      size: size,
      color: color,
    );
  }

  @override
  Icon createCameraIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.camera,
      size: size,
      color: color,
    );
  }

  @override
  Icon createCalendarIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.calendar,
      size: size,
      color: color,
    );
  }

  @override
  Icon createGearIcon({double? size, Color? color}) {
    return Icon(
      CupertinoIcons.gear_alt_fill,
      size: size,
      color: color,
    );
  }
}
