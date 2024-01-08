import 'package:app/components/custom_button_component.dart';
import 'package:app/components/empty_content_info_component.dart';
import 'package:app/config/themes/global_material_theme.dart';
import 'package:app/features/internet_connection_checker/bloc/internet_connection_checker_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  const NoInternetConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: GlobalMaterialTheme.lightTheme,
      child: const Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Description(),
                SizedBox(height: 64),
                _TryAgainButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return const EmptyContentInfoComponent(
      icon: MdiIcons.wifiOff,
      title: 'Brak połączenia internetowego',
      subtitle:
          'Wygląda na to, że utraciłeś połączenie z internetem. Sprawdź swoje ustawienia internetowe aby móc korzystać z aplikacji.',
    );
  }
}

class _TryAgainButton extends StatelessWidget {
  const _TryAgainButton();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: 'Spróbuj ponownie',
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<InternetConnectionCheckerBloc>().add(
          const InternetConnectionCheckerEventCheckInternetConnection(),
        );
  }
}
