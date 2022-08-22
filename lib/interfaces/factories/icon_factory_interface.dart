import 'package:flutter/widgets.dart';

abstract class IconFactoryInterface {
  Icon createAccountIcon({double? size, Color? color});

  Icon createLockIcon({double? size, Color? color});

  Icon createEnvelopeIcon({double? size, Color? color});

  Icon createCloseIcon({double? size, Color? color});

  Icon createBookIcon({double? size, Color? color});

  Icon createImageIcon({double? size, Color? color});

  Icon createCameraIcon({double? size, Color? color});
}