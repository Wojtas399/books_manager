import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'features/initial_home/initial_home.dart';
import 'interfaces/widget_factory.dart';
import 'providers/widget_factory_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => _getWidgetFactory(),
      child: Builder(
        builder: (BuildContext context) {
          final WidgetFactory widgetFactory = context.read<WidgetFactory>();
          return widgetFactory.createApp(
            title: 'BooksManager',
            home: InitialHome(),
          );
        },
      ),
    );
  }

  WidgetFactory _getWidgetFactory() {
    if (Platform.isIOS) {
      return WidgetFactoryProvider.providerCupertinoWidgetFactory();
    } else {
      return WidgetFactoryProvider.provideMaterialWidgetFactory();
    }
  }
}
