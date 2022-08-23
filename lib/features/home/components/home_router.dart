import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/routes.dart';
import '../../../interfaces/factories/navigation_factory.dart';
import '../../profile/profile_screen.dart';
import 'home_content.dart';

class HomeRouter extends StatelessWidget {
  const HomeRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
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
      case Routes.profile:
        return navigationFactory.createPageRoute(
          page: const ProfileScreen(),
        );
      default:
        return navigationFactory.createPageRoute(
          page: const HomeContent(),
        );
    }
  }
}
