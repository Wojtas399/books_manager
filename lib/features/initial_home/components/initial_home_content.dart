import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/on_tap_focus_lose_area_component.dart';
import '../../../config/themes/app_colors.dart';
import '../../../interfaces/factories/widget_factory_interface.dart';
import 'initial_home_form_card.dart';

class InitialHomeContent extends StatelessWidget {
  const InitialHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final widgetFactory = context.read<WidgetFactoryInterface>();
    return widgetFactory.createScaffold(
      withAppBar: false,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              AppColors.secondary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: OnTapFocusLoseAreaComponent(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                InitialHomeFormCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}