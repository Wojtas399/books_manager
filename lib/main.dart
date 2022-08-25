import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/themes/global_material_theme.dart';
import 'features/sign_in/sign_in_screen.dart';
import 'global_provider.dart';

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
      child: MaterialApp(
        title: 'BooksManager',
        theme: GlobalMaterialTheme.lightTheme,
        home: const SignInScreen(),
      ),
    );
  }
}
