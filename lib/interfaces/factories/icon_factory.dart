import 'package:flutter/widgets.dart';

abstract class IconFactory {
  Icon createAccountIcon({double? size, Color? color});

  Icon createLockIcon({double? size, Color? color});

  Icon createEnvelopeIcon({double? size, Color? color});

  Icon createCloseIcon({double? size, Color? color});

  Icon createBookIcon({double? size, Color? color});

  Icon createLibraryIcon({double? size, Color? color});

  Icon createImageIcon({double? size, Color? color});

  Icon createCameraIcon({double? size, Color? color});

  Icon createCalendarIcon({double? size, Color? color});

  Icon createGearIcon({double? size, Color? color});
}