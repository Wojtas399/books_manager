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
}
