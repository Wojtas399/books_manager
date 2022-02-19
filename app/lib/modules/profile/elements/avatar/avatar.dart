import 'package:app/core/services/image_service.dart';
import 'package:app/modules/profile/bloc/profile_bloc.dart';
import 'package:app/modules/profile/bloc/profile_query.dart';
import 'package:app/modules/profile/elements/avatar/avatar_controller.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';
import 'package:app/interfaces/avatars/avatar_interface.dart';
import 'package:app/widgets/avatars/avatar_background.dart';
import 'package:app/widgets/avatars/custom_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileQuery>(
      builder: (context, query) {
        AvatarController controller = AvatarController(
          profileBloc: context.read<ProfileBloc>(),
          imageService: ImageService(),
          profileScreenDialogs: ProfileScreenDialogs(),
        );
        return StreamBuilder(
          stream: query.avatar$,
          builder: (context, AsyncSnapshot<AvatarInterface> snapshot) {
            AvatarInterface? avatar = snapshot.data;
            if (avatar != null) {
              return GestureDetector(
                child: AvatarCircleShape(
                  isSelected: false,
                  size: 160,
                  child: _Avatar(
                    avatar: avatar,
                  ),
                ),
                onTap: () => controller.selectAvatarChoiceOption(),
              );
            }
            return Text('no avatara');
          },
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  late final String? _imgUrl;
  late final String? _assetsPath;

  _Avatar({required AvatarInterface avatar}) {
    if (avatar is CustomAvatarInterface) {
      _imgUrl = avatar.imgUrl;
      _assetsPath = null;
    } else if (avatar is StandardAvatarInterface) {
      _imgUrl = null;
      _assetsPath = avatar.imgAssetsPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? imgUrl = _imgUrl;
    String? assetsPath = _assetsPath;

    return imgUrl != null
        ? _CustomAvatar(imageUrl: imgUrl)
        : assetsPath != null
            ? _BasicAvatar(assetsPath: assetsPath)
            : Text('no avatar');
  }
}

class _CustomAvatar extends StatelessWidget {
  final String imageUrl;

  const _CustomAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CustomAvatar(imageUrl: imageUrl);
  }
}

class _BasicAvatar extends StatelessWidget {
  final String assetsPath;

  const _BasicAvatar({required this.assetsPath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(assetsPath, scale: 4.5);
  }
}
