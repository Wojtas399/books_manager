import 'package:app/config/themes/button_theme.dart';
import 'package:app/constants/route_paths/start_route_path.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/theme.dart';
import 'package:hexcolor/hexcolor.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor(AppColors.LIGHT_BLUE),
      child: Stack(
        children: [
          _LogoImage(),
          _MainContent(),
          _Buttons(),
        ],
      ),
    );
  }
}

class _LogoImage extends StatelessWidget {
  const _LogoImage();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 16,
      child: Image.asset(
        'assets/images/Logo.png',
        scale: 3.8,
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 580,
        padding: EdgeInsets.only(top: 110, left: 25),
        decoration: BoxDecoration(
          color: HexColor(AppColors.LIGHT_GREEN),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(500),
          ),
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 105,
      bottom: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text('LOGOWANIE'),
            style: ButtonStyles.bigButton(
              color: AppColors.DARK_GREEN2,
              context: context,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(StartRoutePath.SIGN_IN);
            },
          ),
          SizedBox(
            height: 25,
          ),
          ElevatedButton(
            child: Text('REJESTRACJA'),
            style: ButtonStyles.bigButton(
              color: AppColors.DARK_GREEN2,
              context: context,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(StartRoutePath.SIGN_UP);
            },
          ),
        ],
      ),
    );
  }
}
