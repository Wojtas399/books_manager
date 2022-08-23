import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../interfaces/factories/icon_factory.dart';

class MaterialIconFactory implements IconFactory {
  @override
  Icon createAccountIcon({double? size, Color? color}) {
    return Icon(
      Icons.person_outline_rounded,
      size: size,
      color: color,
    );
  }

  @override
  Icon createLockIcon({double? size, Color? color}) {
    return Icon(
      Icons.lock_outline_rounded,
      size: size,
      color: color,
    );
  }

  @override
  Icon createEnvelopeIcon({double? size, Color? color}) {
    return Icon(
      Icons.email_outlined,
      size: size,
      color: color,
    );
  }

  @override
  Icon createCloseIcon({double? size, Color? color}) {
    return Icon(
      Icons.close,
      size: size,
      color: color,
    );
  }

  @override
  Icon createBookIcon({double? size, Color? color}) {
    return Icon(
      MdiIcons.bookOpenOutline,
      size: size,
      color: color,
    );
  }

  @override
  Icon createLibraryIcon({double? size, Color? color}) {
    return Icon(
      Icons.library_books_outlined,
      size: size,
      color: color,
    );
  }

  @override
  Icon createImageIcon({double? size, Color? color}) {
    return Icon(
      Icons.image_outlined,
      size: size,
      color: color,
    );
  }

  @override
  Icon createCameraIcon({double? size, Color? color}) {
    return Icon(
      Icons.camera_alt_outlined,
      size: size,
      color: color,
    );
  }

  @override
  Icon createCalendarIcon({double? size, Color? color}) {
    return Icon(
      Icons.calendar_month_outlined,
      size: size,
      color: color,
    );
  }
}
