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
}