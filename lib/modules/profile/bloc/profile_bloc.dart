import 'package:app/core/user/user_bloc.dart';
import 'package:app/core/user/user_query.dart';
import 'package:app/modules/profile/bloc/profile_actions.dart';
import 'package:app/modules/profile/bloc/profile_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileActions, ProfileQuery> {
  UserQuery userQuery;
  UserBloc userBloc;

  ProfileBloc({required this.userQuery, required this.userBloc})
      : super(ProfileQuery(userQuery: userQuery));

  @override
  Stream<ProfileQuery> mapEventToState(ProfileActions event) async* {
    if (event is ProfileActionsChangeAvatar) {
      await userBloc.updateAvatar(event.avatar);
    } else if (event is ProfileActionsChangeUsername) {
      await userBloc.updateUsername(event.newUsername);
    } else if (event is ProfileActionsChangeEmail) {
      await userBloc.updateEmail(event.newEmail, event.password);
    } else if (event is ProfileActionsChangePassword) {
      await userBloc.updatePassword(event.currentPassword, event.newPassword);
    }
  }
}
