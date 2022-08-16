import 'package:app/modules/profile/bloc/profile_bloc.dart';
import 'package:app/modules/profile/bloc/profile_query.dart';
import 'package:app/modules/profile/elements/user_info/user_info_controller.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';
import 'package:app/widgets/icons/default_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileQuery>(
      builder: (context, query) {
        UserInfoController controller = UserInfoController(
          profileBloc: context.read<ProfileBloc>(),
          profileScreenDialogs: ProfileScreenDialogs(),
        );

        return Column(
          children: [
            _Username(
              username$: query.username$,
              onTap: controller.onClickUsername,
            ),
            Divider(height: 1),
            _Email(email$: query.email$, onTap: controller.onClickEmail),
            Divider(height: 1),
            _Password(onTap: controller.onClickPassword),
          ],
        );
      },
    );
  }
}

class _Username extends StatelessWidget {
  final Stream<String?> username$;
  final Function(String? username) onTap;

  const _Username({required this.username$, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: username$,
      builder: (_, AsyncSnapshot<String?> snapshot) {
        String? username = snapshot.data;
        return _InfoElement(
          text: username ?? '',
          icon: Icons.person_outlined,
          onTap: () => onTap(username),
        );
      },
    );
  }
}

class _Email extends StatelessWidget {
  final Stream<String?> email$;
  final Function(String email) onTap;

  const _Email({required this.email$, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: email$,
      builder: (_, AsyncSnapshot<String?> snapshot) {
        String? email = snapshot.data;
        return _InfoElement(
          text: email ?? '',
          icon: Icons.email_outlined,
          onTap: () => onTap(email ?? ''),
        );
      },
    );
  }
}

class _Password extends StatelessWidget {
  final Function() onTap;

  const _Password({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _InfoElement(
      text: 'Hasło',
      icon: Icons.lock_outlined,
      onTap: () => onTap(),
    );
  }
}

class _InfoElement extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function() onTap;

  const _InfoElement({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      title: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      leading: DefaultIcon(icon: icon),
      onTap: () => onTap(),
    );
  }
}
