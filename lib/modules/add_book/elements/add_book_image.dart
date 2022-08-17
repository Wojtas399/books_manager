import 'dart:io';
import 'package:app/config/themes/button_theme.dart';
import 'package:app/config/themes/app_colors.dart';
import 'package:app/widgets/buttons/medium_green_button.dart';
import 'package:flutter/material.dart';

class AddBookImage extends StatelessWidget {
  final ValueNotifier<String?> imgPath;
  final Function onClickImageButton;
  final Function onClickSummaryButton;

  const AddBookImage({
    required this.imgPath,
    required this.onClickImageButton,
    required this.onClickSummaryButton,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: imgPath,
      builder: (_, String? path, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: path != null
              ? _BodyWithImage(
                  imgPath: path,
                  onClickImageButton: () {
                    onClickImageButton();
                  },
                  onClickSummaryButton: () {
                    onClickSummaryButton();
                  },
                )
              : _BodyWithoutImage(
                  onClickAddImageButton: () {
                    onClickImageButton();
                  },
                ),
        );
      },
    );
  }
}

class _BodyWithoutImage extends StatelessWidget {
  final Function onClickAddImageButton;

  const _BodyWithoutImage({required this.onClickAddImageButton});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MediumGreenButton(
        text: 'Dodaj zdjęcie',
        icon: Icons.add_rounded,
        onPressed: () {
          onClickAddImageButton();
        },
      ),
    );
  }
}

class _BodyWithImage extends StatelessWidget {
  final String imgPath;
  final Function onClickImageButton;
  final Function onClickSummaryButton;

  const _BodyWithImage({
    required this.imgPath,
    required this.onClickImageButton,
    required this.onClickSummaryButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Image(imgPath: imgPath),
        SizedBox(height: 16.0),
        _Buttons(
          onClickImageButton: () {
            onClickImageButton();
          },
          onClickSummaryButton: () {
            onClickSummaryButton();
          },
        ),
      ],
    );
  }
}

class _Image extends StatelessWidget {
  final String imgPath;

  const _Image({required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(File(imgPath)),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final Function onClickImageButton;
  final Function onClickSummaryButton;

  const _Buttons({
    required this.onClickImageButton,
    required this.onClickSummaryButton,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              label: Text('Zmień zdjęcie'),
              icon: Icon(Icons.edit_rounded),
              style: ButtonStyles.mediumButton(
                color: AppColors.DARK_BLUE,
                context: context,
              ),
              onPressed: () {
                onClickImageButton();
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: MediumGreenButton(
              text: 'Podsumowanie',
              icon: Icons.menu_book,
              onPressed: () {
                onClickSummaryButton();
              },
            ),
          ),
        ),
      ],
    );
  }
}
