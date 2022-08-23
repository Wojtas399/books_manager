import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/routes.dart';
import '../../../interfaces/factories/navigation_factory.dart';
import '../../../providers/navigator_key_provider.dart';
import '../../settings/settings_screen.dart';
import 'home_content.dart';

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
      onGenerateRoute: (RouteSettings routeSettings) => _onGenerateRoute(
        routeSettings,
        context,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(
    RouteSettings routeSettings,
    BuildContext context,
  ) {
    final NavigationFactory navigationFactory =
        context.read<NavigationFactory>();
    switch (routeSettings.name) {
      case Routes.home:
        return navigationFactory.createPageRoute(
          page: const HomeContent(),
        );
      case Routes.settings:
        return navigationFactory.createPageRoute(
          page: const SettingsScreen(),
        );
      default:
        return navigationFactory.createPageRoute(
          page: const HomeContent(),
        );
    }
  }
}
