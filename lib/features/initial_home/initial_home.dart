import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../interfaces/widget_factory.dart';

class InitialHome extends StatelessWidget {
  const InitialHome({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactory widgetFactory = context.read<WidgetFactory>();
    return widgetFactory.createScaffold(
      appBarTitle: 'Witaj w domu!',
      child: Center(
        child: Text('WOW'),
      ),
    );
  }
}
