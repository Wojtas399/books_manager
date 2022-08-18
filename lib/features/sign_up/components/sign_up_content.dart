import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/avatar_selection_component.dart';
import '../../../components/section_component.dart';
import '../../../config/themes/app_colors.dart';
import '../../../interfaces/factories/icon_factory_interface.dart';
import '../../../interfaces/factories/widget_factory_interface.dart';
import '../../initial_home/bloc/initial_home_bloc.dart';
import 'sign_up_inputs.dart';
import 'sign_up_submit_button.dart';

class SignUpContent extends StatelessWidget {
  const SignUpContent({super.key});

  @override
  Widget build(BuildContext context) {
    final widgetFactory = context.read<WidgetFactoryInterface>();
    final iconFactory = context.read<IconFactoryInterface>();
    return widgetFactory.createScaffold(
      appBarTitle: 'Rejestracja',
      appBarBackgroundColor: AppColors.background,
      appBarWithElevation: false,
      leadingIcon: iconFactory.createCloseIcon(),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 24,
              top: 16,
            ),
            child: Column(
              children: const [
                AvatarSelectionComponent(
                  size: 210,
                ),
                SizedBox(height: 16),
                SectionComponent(
                  sectionName: 'Dane',
                  withBottomDivider: false,
                  child: SignUpInputs(),
                ),
                SignUpSubmitButton(),
                SizedBox(height: 16),
                _AlternativeOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlternativeOptions extends StatelessWidget {
  const _AlternativeOptions();

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 12,
      color: AppColors.grey,
    );
    return Column(
      children: [
        GestureDetector(
          onTap: () => _onSignInPressed(context),
          child: Text(
            'Masz już konto? Zaloguj się!',
            style: textStyle,
          ),
        ),
      ],
    );
  }

  void _onSignInPressed(BuildContext context) {
    context.read<InitialHomeBloc>().add(
          InitialHomeEventChangeMode(mode: InitialHomeMode.signIn),
        );
  }
}
