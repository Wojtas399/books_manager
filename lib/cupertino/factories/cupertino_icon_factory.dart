import 'package:flutter/cupertino.dart';

import '../../interfaces/factories/icon_factory_interface.dart';

class CupertinoIconFactory implements IconFactoryInterface {
  @override
  Icon createAccountIcon() {
    return const Icon(CupertinoIcons.person);
  }

  @override
  Icon createLockIcon() {
    return const Icon(CupertinoIcons.lock);
  }

  @override
  Icon createEnvelopeIcon() {
    return const Icon(CupertinoIcons.envelope);
  }

  @override
  Icon createCloseIcon() {
    return const Icon(CupertinoIcons.clear);
  }

  @override
  Icon createBookIcon() {
    return const Icon(CupertinoIcons.book);
  }

  @override
  Icon createImageIcon() {
    return const Icon(CupertinoIcons.photo);
  }

  @override
  Icon createCameraIcon() {
    return const Icon(CupertinoIcons.camera);
  }
}