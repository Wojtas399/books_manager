import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../interfaces/factories/widget_factory.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactory widgetFactory = context.read<WidgetFactory>();
    return widgetFactory.createScaffold(
      child: const Center(
        child: Text('Profile screen'),
      ),
    );
  }
}
