import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../interfaces/factories/widget_factory_interface.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactoryInterface widgetFactory =
        context.read<WidgetFactoryInterface>();
    return widgetFactory.createScaffold(
      child: const Center(
        child: Text('Welcome home!'),
      ),
    );
  }
}
