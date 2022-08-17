import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'features/initial_home/initial_home.dart';
import 'global_provider.dart';
import 'interfaces/factories/widget_factory_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalProvider(
      child: Builder(
        builder: (BuildContext context) {
          final widgetFactory = context.read<WidgetFactoryInterface>();
          return widgetFactory.createApp(
            title: 'BooksManager',
            home: const InitialHome(),
          );
        },
      ),
    );
  }
}
