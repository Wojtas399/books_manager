import 'package:flutter/widgets.dart';

import '../../../components/avatar_with_change_option_component.dart';
import '../../../models/avatar.dart';

class SignUpAvatar extends StatelessWidget {
  const SignUpAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return AvatarWithChangeOptionComponent(
      size: 100,
      onAvatarChanged: (Avatar avatar) {
        print('New avatar');
        print(avatar);
      },
    );
  }
}