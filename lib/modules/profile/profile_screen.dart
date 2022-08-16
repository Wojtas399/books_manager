import 'package:app/core/user/user_bloc.dart';
import 'package:app/core/user/user_query.dart';
import 'package:app/modules/profile/bloc/profile_bloc.dart';
import 'package:app/modules/profile/elements/avatar/avatar.dart';
import 'package:app/modules/profile/elements/user_info/user_info.dart';
import 'package:app/widgets/app_bars/none_elevation_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app/constants/theme.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(
        userQuery: Provider.of<UserQuery>(context),
        userBloc: Provider.of<UserBloc>(context),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: NoneElevationAppBar(
          backgroundColor: AppColors.LIGHT_GREEN,
          text: 'Twój profil',
        ),
        body: Row(
          children: [
            Expanded(
              flex: 10,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      color: HexColor(AppColors.LIGHT_GREEN),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Avatar(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: UserInfo(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
