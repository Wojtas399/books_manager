import 'dart:io';
import 'dart:ui';
import 'package:app/widgets/avatars/avatar_background.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app/constants/theme.dart';

class CustomAvatar extends StatelessWidget {
  final bool isChosen;
  final VoidCallback onClick;
  final String imgPath;

  CustomAvatar({
    required this.isChosen,
    required this.onClick,
    required this.imgPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: AvatarBackground(
        size: 60,
        isChosen: isChosen,
        child: imgPath == ''
            ? Icon(
                Icons.add,
                color: HexColor(AppColors.DARK_GREEN),
                size: 40,
              )
            : Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: FileImage(File(imgPath)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(imgPath)),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
