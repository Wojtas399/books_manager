import 'package:app/config/animations/fade_route_animation.dart';
import 'package:app/config/animations/slide_up_route_animation.dart';
import 'package:app/config/routes.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/features/book_creator/book_creator_screen.dart';
import 'package:app/features/book_editor/book_editor_screen.dart';
import 'package:app/features/book_preview/book_preview_arguments.dart';
import 'package:app/features/book_preview/book_preview_screen.dart';
import 'package:app/features/day_preview/day_preview_screen.dart';
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
      observers: [
        HeroController(),
      ],
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
        return FadeRouteAnimation(
          page: BookPreviewScreen(
            arguments: routeSettings.arguments as BookPreviewArguments,
          ),
        );
      case Routes.bookEditor:
        return MaterialPageRoute(
          builder: (_) => BookEditorScreen(
            bookId: routeSettings.arguments as String,
          ),
        );
      case Routes.dayPreview:
        return SlideUpRouteAnimation(
          page: DayPreviewScreen(
            readBooks: routeSettings.arguments as List<ReadBook>,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const HomeContent(),
        );
    }
  }
}
