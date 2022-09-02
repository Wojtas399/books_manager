import 'package:app/config/routes.dart';
import 'package:app/features/book_creator/book_creator_screen.dart';
import 'package:app/features/book_preview/book_preview_screen.dart';
import 'package:app/features/home/components/home_content.dart';
import 'package:app/features/settings/settings_screen.dart';
import 'package:app/providers/navigator_key_provider.dart';
import 'package:flutter/material.dart';

class HomeRouter extends StatefulWidget {
  const HomeRouter({super.key});

  @override
  State<StatefulWidget> createState() => _HomeRouterState();
}

class _HomeRouterState extends State<HomeRouter> {
  @override
  void initState() {
    NavigatorKeyProvider.setNewNavigatorKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigatorKeyProvider.getKey(),
      initialRoute: Routes.home,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeContent(),
          settings: routeSettings,
        );
      case Routes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case Routes.bookCreator:
        return MaterialPageRoute(
          builder: (_) => const BookCreatorScreen(),
        );
      case Routes.bookPreview:
        return MaterialPageRoute(
          builder: (_) => BookPreviewScreen(
            bookId: routeSettings.arguments as String,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const HomeContent(),
        );
    }
  }
}
