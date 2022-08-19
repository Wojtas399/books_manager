import 'package:flutter/material.dart';

import '../../interfaces/factories/icon_factory_interface.dart';

class MaterialIconFactory implements IconFactoryInterface {
  @override
  Icon createAccountIcon() {
    return const Icon(Icons.person_outline_rounded);
  }

  @override
  Icon createLockIcon() {
    return const Icon(Icons.lock_outline_rounded);
  }

  @override
  Icon createEnvelopeIcon() {
    return const Icon(Icons.email_outlined);
  }

  @override
  Icon createCloseIcon() {
    return const Icon(Icons.close);
  }

  @override
  Icon createBookIcon() {
    return const Icon(Icons.library_books_outlined);
  }

  @override
  Icon createImageIcon() {
    return const Icon(Icons.image_outlined);
  }

  @override
  Icon createCameraIcon() {
    return const Icon(Icons.camera_alt_outlined);
  }
}
