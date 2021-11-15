import 'package:app/core/user/user_bloc.dart';
import 'package:app/modules/profile/elements/user_info/user_info_controller.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';
import 'package:app/widgets/icons/default_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserInfoController controller = UserInfoController(
        userBloc: context.read<UserBloc>(),
        profileScreenDialogs: ProfileScreenDialogs());

    return Column(
      children: [
        _Username(
          username$: controller.username$,
          onTap: controller.onClickUsername,
        ),
        Divider(height: 1),
        _Email(email$: controller.email$, onTap: controller.onClickEmail),
        Divider(height: 1),
        _Password(onTap: controller.onClickPassword),
      ],
    );
  }
}

class _Username extends StatelessWidget {
  final Stream<String?> username$;
  final Function() onTap;

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
          onTap: () => onTap(),
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
