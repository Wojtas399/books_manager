import 'package:flutter/material.dart';
import 'package:app/modules/sign_up/sign_up_bloc.dart';
import 'package:app/modules/sign_up/sign_up_event.dart';
import 'package:app/modules/sign_up/sing_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/common/enum/avatar_type.dart';
import 'package:app/modules/sign_up/elements/basic_avatar.dart';
import 'package:app/modules/sign_up/elements/custom_avatar.dart';
import 'package:image_picker/image_picker.dart';

class SignUpAvatars extends StatelessWidget {
  final List avatarsOrder = [
    AvatarType.red,
    AvatarType.green,
    AvatarType.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: avatarsOrder.map((element) {
              return Row(
                children: [
                  BasicAvatar(
                    type: element,
                    isChosen: state.avatarType == element,
                    onClick: () {
                      context
                          .read<SignUpBloc>()
                          .add(SignUpAvatarTypeChanged(avatarType: element));
                    },
                  ),
                  SizedBox(width: 16),
                ],
              );
            }).toList(),
          ),
          CustomAvatar(
            isChosen: state.avatarType == AvatarType.custom,
            imgPath: state.customAvatarPath,
            onClick: () async {
              context
                  .read<SignUpBloc>()
                  .add(SignUpAvatarTypeChanged(avatarType: AvatarType.custom));
              if (state.avatarType == AvatarType.custom ||
                  state.customAvatarPath == '') {
                try {
                  String imgPath = await _getImageFromGallery();
                  context
                      .read<SignUpBloc>()
                      .add(SignUpCustomAvatarPathChanged(imagePath: imgPath));
                } catch (error) {
                  print('Error while getting image: $error');
                }
              }
            },
          ),
        ],
      );
    });
  }

  Future<String> _getImageFromGallery() async {
    final picker = ImagePicker();
    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return pickedFile.path;
      }
      return '';
    } catch (error) {
      throw Exception(error);
    }
  }
}
