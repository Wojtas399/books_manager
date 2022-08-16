import 'dart:io';
import 'package:app/widgets/app_bars/dialog_app_bar.dart';
import 'package:app/widgets/buttons/medium_green_button.dart';
import 'package:app/widgets/buttons/medium_red_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookDetailsNewImagePreview extends StatelessWidget {
  final String imgPath;

  const BookDetailsNewImagePreview({required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DialogAppBar(title: 'Zatwierdź nowe zdjęcie'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Image(imgPath: imgPath),
          SizedBox(height: 32),
          _Buttons(),
        ],
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
  const _Buttons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 8.0),
            child: MediumRedButton(
              text: 'Anuluj',
              icon: Icons.close,
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 16.0),
            child: MediumGreenButton(
              text: 'Zapisz',
              icon: Icons.check,
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ),
        ),
      ],
    );
  }
}
