import 'package:flutter/material.dart';
import 'package:app/modules/sign_up/sign_up_bloc.dart';
import 'package:app/modules/sign_up/sign_up_event.dart';
import 'package:app/modules/sign_up/sing_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/modules/sign_up/elements/standard_avatar.dart';
import 'package:app/modules/sign_up/elements/custom_avatar.dart';

class SignUpAvatars extends StatelessWidget {
  const SignUpAvatars();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StandardAvatars(selectedAvatarType: state.avatarType),
            CustomAvatar(
              isSelected: state.avatarType == AvatarType.custom,
              imgPath: state.customAvatarPath,
            ),
          ],
        );
      },
    );
  }
}

class _StandardAvatars extends StatelessWidget {
  final AvatarType selectedAvatarType;

  const _StandardAvatars({required this.selectedAvatarType});

  @override
  Widget build(BuildContext context) {
    final List<AvatarType> standardAvatars = [
      AvatarType.red,
      AvatarType.green,
      AvatarType.blue,
    ];
    return Row(
      children: standardAvatars.map(
        (type) {
          return Row(
            children: [
              StandardAvatar(
                avatarType: type,
                isSelected: selectedAvatarType == type,
                onSelect: () => _saveChoice(context, type),
              ),
              SizedBox(width: 16),
            ],
          );
        },
      ).toList(),
    );
  }

  _saveChoice(BuildContext context, AvatarType type) {
    context.read<SignUpBloc>().add(SignUpAvatarTypeChanged(avatarType: type));
  }
}
