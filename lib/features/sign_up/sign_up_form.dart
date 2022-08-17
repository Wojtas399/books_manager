import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../interfaces/factories/widget_factory_interface.dart';
import '../initial_home/bloc/initial_home_bloc.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final widgetFactory = context.read<WidgetFactoryInterface>();
    return Column(
      children: [
        const Text('REJESTRACJA'),
        widgetFactory.createButton(
          onPressed: () => _onPressed(context),
          text: 'Logowanie',
        ),
      ],
    );
  }

  void _onPressed(BuildContext context) {
    context
        .read<InitialHomeBloc>()
        .add(InitialHomeEventChangeMode(mode: InitialHomeMode.signIn));
  }
}
