import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/themes/app_colors.dart';
import '../interfaces/factories/icon_factory.dart';
import '../interfaces/factories/widget_factory.dart';
import '../models/avatar.dart';
import 'avatar_component.dart';

class BasicAvatarSelectionComponent extends StatelessWidget {
  const BasicAvatarSelectionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactory widgetFactory = context.read<WidgetFactory>();
    final IconFactory iconFactory = context.read<IconFactory>();
    const double avatarSize = 140;
    const Widget gap = SizedBox(height: 32);

    return widgetFactory.createScaffold(
      appBarTitle: 'Wybierz avatar',
      appBarBackgroundColor: AppColors.background,
      appBarWithElevation: false,
      leadingIcon: iconFactory.createCloseIcon(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AvatarComponent(
                  avatar: const BasicAvatar(type: BasicAvatarType.red),
                  size: avatarSize,
                  onPressed: () {
                    Navigator.pop(context, BasicAvatarType.red);
                  },
                ),
                gap,
                AvatarComponent(
                  avatar: const BasicAvatar(type: BasicAvatarType.green),
                  size: avatarSize,
                  onPressed: () {
                    Navigator.pop(context, BasicAvatarType.green);
                  },
                ),
                gap,
                AvatarComponent(
                  avatar: const BasicAvatar(type: BasicAvatarType.blue),
                  size: avatarSize,
                  onPressed: () {
                    Navigator.pop(context, BasicAvatarType.blue);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
