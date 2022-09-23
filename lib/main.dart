import 'package:app/providers/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create: (_) => ThemeProvider(),
      child: BlocBuilder<ThemeProvider, ThemeMode>(
        builder: (_, ThemeMode themeMode) {
          return GlobalProvider(
            child: MaterialApp(
              title: 'BooksManager',
              themeMode: themeMode,
              theme: GlobalMaterialTheme.lightTheme,
              darkTheme: GlobalMaterialTheme.darkTheme,
              home: const SignInScreen(),
            ),
          );
        },
      ),
    );
  }
}
