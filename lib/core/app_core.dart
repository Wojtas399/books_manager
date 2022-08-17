import 'package:app/config/routes/start_routes.dart';
import 'package:app/constants/route_paths/start_route_path.dart';
import 'package:app/config/themes/app_colors.dart';
import 'package:app/core/auth/auth_bloc.dart';
import 'package:app/injection/backend_provider.dart';
import 'package:app/interfaces/auth_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'keys.dart';

class AppCore extends StatelessWidget {
  const AppCore();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => BackendProvider.provideAuthInterface(),
      child: Provider<AuthBloc>(
        create: (context) => AuthBloc(
          authInterface: context.read<AuthInterface>(),
        ),
        child: MaterialApp(
          navigatorKey: Keys.globalNavigatorKey,
          initialRoute: StartRoutePath.START,
          onGenerateRoute: StartRoutes.generateRoute,
          theme: ThemeData(
            scaffoldBackgroundColor: HexColor(
              AppColors.LIGHT_BLUE,
            ),
          ),
        ),
      ),
    );
  }
}
