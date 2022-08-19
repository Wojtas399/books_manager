import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/themes/app_colors.dart';
import '../interfaces/factories/icon_factory_interface.dart';
import '../interfaces/factories/widget_factory_interface.dart';
import '../models/avatar.dart';
import 'avatar_component.dart';

class BasicAvatarSelectionComponent extends StatelessWidget {
  const BasicAvatarSelectionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactoryInterface widgetFactory =
        context.read<WidgetFactoryInterface>();
    final IconFactoryInterface iconFactory =
        context.read<IconFactoryInterface>();
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
              children: BasicAvatarType.values
                  .map(
                    (BasicAvatarType type) => _BasicAvatarTypeItem(type: type),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _BasicAvatarTypeItem extends StatelessWidget {
  final BasicAvatarType type;

  const _BasicAvatarTypeItem({required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AvatarComponent(
          avatar: BasicAvatar(type: type),
          size: 80,
          onPressed: () {
            Navigator.pop(context, type);
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
