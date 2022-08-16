import 'dart:io';
import 'dart:ui';
import 'package:app/core/services/image_service.dart';
import 'package:app/widgets/avatars/avatar_background.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app/constants/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../sign_up_bloc.dart';
import '../sign_up_event.dart';
import '../sing_up_state.dart';

class CustomAvatar extends StatelessWidget {
  final ImageService imageService = new ImageService();
  final bool isSelected;
  final String imgPath;

  CustomAvatar({
    required this.isSelected,
    required this.imgPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selectImageFromGallery(context);
      },
      child: AvatarCircleShape(
        size: 60,
        isSelected: isSelected,
        child: imgPath == '' ? _AddIcon() : _AvatarImage(imgPath: imgPath),
      ),
    );
  }

  _selectImageFromGallery(BuildContext context) async {
    _markAsSelected(context);
    if (isSelected || _noImageIsSet()) {
      try {
        String? pathToImageFromGallery =
            await imageService.getImageFromGallery();
        if (pathToImageFromGallery != null) {
          _savePathToImageFromGallery(pathToImageFromGallery, context);
        }
      } catch (error) {
        print('Error while getting image: $error');
      }
    }
  }

  _markAsSelected(BuildContext context) {
    context.read<SignUpBloc>().add(SignUpAvatarTypeChanged(
          avatarType: AvatarType.custom,
        ));
  }

  bool _noImageIsSet() {
    return imgPath == '';
  }

  _savePathToImageFromGallery(String path, BuildContext context) {
    context
        .read<SignUpBloc>()
        .add(SignUpCustomAvatarPathChanged(imagePath: path));
  }
}

class _AddIcon extends StatelessWidget {
  const _AddIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.add,
      color: HexColor(AppColors.DARK_GREEN),
      size: 40,
    );
  }
}

class _AvatarImage extends StatelessWidget {
  final String imgPath;

  const _AvatarImage({required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return _BackgroundImage(
      imgPath: imgPath,
      child: _BlurEffect(
        child: _Image(imgPath: imgPath),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  final String imgPath;
  final Widget child;

  const _BackgroundImage({required this.imgPath, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: FileImage(File(imgPath)),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}

class _BlurEffect extends StatelessWidget {
  final Widget child;

  const _BlurEffect({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        child: child,
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String imgPath;

  const _Image({required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(File(imgPath)),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
