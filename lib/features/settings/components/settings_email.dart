import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsEmail extends StatelessWidget {
  const SettingsEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final String? loggedUserEmail = context.select(
      (SettingsBloc bloc) => bloc.state.loggedUserEmail,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            loggedUserEmail ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
