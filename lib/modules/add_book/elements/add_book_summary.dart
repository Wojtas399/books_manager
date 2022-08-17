import 'dart:io';
import 'package:app/config/themes/app_colors.dart';
import 'package:app/modules/add_book/add_book_model.dart';
import 'package:app/widgets/buttons/medium_green_button.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AddBookSummary extends StatelessWidget {
  final ValueNotifier<String?> imgPath;
  final ValueNotifier<AddBookFormModel> bookDetails;
  final ValueNotifier<bool> isButtonDisabled;
  final Function onClickButton;

  const AddBookSummary({
    required this.imgPath,
    required this.bookDetails,
    required this.isButtonDisabled,
    required this.onClickButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 10,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ImageSection(imgPath: imgPath),
                _DetailsSection(details: bookDetails),
              ],
            ),
          ),
        ),
        Expanded(
          child: _SaveButton(
            isDisabled: isButtonDisabled,
            onClick: () {
              onClickButton();
            },
          ),
        )
      ],
    );
  }
}

class _ImageSection extends StatelessWidget {
  final ValueNotifier<String?> imgPath;

  const _ImageSection({required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: imgPath,
      builder: (_, String? path, child) {
        return Container(
          height: 250,
          color: HexColor(AppColors.LIGHT_GREEN2),
          padding: EdgeInsets.all(8.0),
          width: double.infinity,
          child: path != null
              ? _Image(imgPath: path)
              : Center(
                  child: Icon(
                    Icons.image,
                    size: 48,
                    color: Colors.black26,
                  ),
                ),
        );
      },
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final ValueNotifier<AddBookFormModel> details;

  const _DetailsSection({required this.details});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: details,
      builder: (_, AddBookFormModel bookDetails, child) {
        return Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailItem(
                title: bookDetails.title == '' ? 'Brak' : bookDetails.title,
                subtitle: 'Tytuł',
              ),
              _DetailItem(
                title: bookDetails.author == '' ? 'Brak' : bookDetails.author,
                subtitle: 'Autor',
              ),
              _DetailItem(
                title: bookDetails.category,
                subtitle: 'Kategoria',
              ),
              _DetailItem(
                title: '${bookDetails.readPages}',
                subtitle: 'Liczba przeczytanych stron',
              ),
              _DetailItem(
                title: '${bookDetails.pages}',
                subtitle: 'Liczba wszystkich stron',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Image extends StatelessWidget {
  final String imgPath;

  const _Image({required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
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

class _DetailItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _DetailItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, style: Theme.of(context).textTheme.bodyText1),
          SizedBox(height: 4),
          Text(title, style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final Function onClick;
  final ValueNotifier<bool> isDisabled;

  const _SaveButton({required this.onClick, required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDisabled,
      builder: (_, bool disabled, child) {
        return Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              top: 0.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: MediumGreenButton(
              text: 'Zapisz',
              icon: Icons.save_rounded,
              onPressed: disabled
                  ? null
                  : () {
                      onClick();
                    },
            ),
          ),
        );
      },
    );
  }
}
