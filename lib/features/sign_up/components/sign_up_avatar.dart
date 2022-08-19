import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/avatar_with_change_option_component.dart';
import '../../../models/avatar.dart';
import '../bloc/sign_up_bloc.dart';

class SignUpAvatar extends StatelessWidget {
  const SignUpAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return AvatarWithChangeOptionComponent(
      size: 100,
      onAvatarChanged: (Avatar avatar) => _onAvatarChanged(avatar, context),
    );
  }

  void _onAvatarChanged(Avatar avatar, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventAvatarChanged(avatar: avatar),
        );
  }
}
