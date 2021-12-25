import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/services/avatar_book_service.dart';
import 'package:app/core/services/image_service.dart';
import 'package:app/core/user/user_bloc.dart';
import 'package:app/modules/profile/bloc/profile_bloc.dart';
import 'package:app/modules/profile/bloc/profile_query.dart';
import 'package:app/modules/profile/elements/avatar/avatar_controller.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';
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
          avatarBookService: AvatarBookService(),
          imageService: ImageService(),
          profileScreenDialogs: ProfileScreenDialogs(),
        );
        return StreamBuilder(
          stream: query.avatarInfo$,
          builder: (context, AsyncSnapshot<AvatarInfo?> snapshot) {
            AvatarInfo? avatarInfo = snapshot.data;

            return GestureDetector(
              child: AvatarBackground(
                isChosen: false,
                size: 160,
                child: _Avatar(
                  imageUrl: avatarInfo != null ? avatarInfo.avatarUrl : '',
                  avatarType: avatarInfo != null
                      ? avatarInfo.avatarType
                      : AvatarType.custom,
                ),
              ),
              onTap: () => controller.openAvatarActionSheet(),
            );
          },
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  final String imageUrl;
  final AvatarType avatarType;

  const _Avatar({required this.imageUrl, required this.avatarType});

  @override
  Widget build(BuildContext context) {
    return avatarType == AvatarType.custom
        ? _CustomAvatar(imageUrl: imageUrl)
        : _BasicAvatar(avatarType: avatarType);
  }
}

class _CustomAvatar extends StatelessWidget {
  final String imageUrl;

  const _CustomAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == '') {
      return Text('');
    }
    return CustomAvatar(imageUrl: imageUrl);
  }
}

class _BasicAvatar extends StatelessWidget {
  final AvatarBookService avatarBookService = AvatarBookService();
  final AvatarType? avatarType;

  _BasicAvatar({required this.avatarType});

  @override
  Widget build(BuildContext context) {
    AvatarType? type = avatarType;
    if (type == null) {
      return Text('');
    }
    return Image.asset(
      'assets/images/' + avatarBookService.getBookFileName(type),
      scale: 4.5,
    );
  }
}
