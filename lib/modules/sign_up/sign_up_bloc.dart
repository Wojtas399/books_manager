import 'package:app/core/auth/auth_bloc.dart';
import 'package:app/models/avatar_model.dart';
import 'package:app/models/operation_status.model.dart';
import 'package:app/models/http_result.model.dart';
import 'package:app/modules/sign_up/sign_up_event.dart';
import 'package:app/modules/sign_up/sing_up_state.dart';
import 'package:app/interfaces/avatar_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpAction, SignUpState> {
  final AuthBloc authBloc;

  SignUpBloc({required this.authBloc}) : super(SignUpState());

  @override
  Stream<SignUpState> mapEventToState(SignUpAction event) async* {
    if (event is SignUpUsernameChanged) {
      yield _stateWithUpdatedUsername(event.username);
    } else if (event is SignUpEmailChanged) {
      yield _stateWithUpdatedEmail(event.email);
    } else if (event is SignUpPasswordChanged) {
      yield _stateWithUpdatedPassword(event.password);
    } else if (event is SignUpPasswordConfirmationChanged) {
      yield _stateWithUpdatedPasswordConfirmation(
        event.passwordConfirmation,
      );
    } else if (event is SignUpAvatarTypeChanged) {
      yield _stateWithUpdatedAvatar(event.avatarType);
    } else if (event is SignUpCustomAvatarPathChanged) {
      yield _stateWithUpdatedCustomAvatar(event.imagePath);
    } else if (event is SignUpSubmitted) {
      yield state.copyWith(signUpStatus: OperationLoading());
      Stream<OperationStatus> signUpResult$ = _signUp(
        username: event.username,
        email: event.email,
        password: event.password,
        avatarType: event.avatarType,
        customAvatarPath: event.customAvatarPath,
      );
      await for (final value in signUpResult$) {
        yield state.copyWith(signUpStatus: value);
      }
    }
  }

  SignUpState _stateWithUpdatedUsername(String username) {
    return state.copyWith(username: username);
  }

  SignUpState _stateWithUpdatedEmail(String email) {
    return state.copyWith(email: email);
  }

  SignUpState _stateWithUpdatedPassword(String password) {
    return state.copyWith(password: password);
  }

  SignUpState _stateWithUpdatedPasswordConfirmation(
    String passwordConfirmation,
  ) {
    return state.copyWith(passwordConfirmation: passwordConfirmation);
  }

  SignUpState _stateWithUpdatedAvatar(AvatarType avatarType) {
    return state.copyWith(avatarType: avatarType);
  }

  SignUpState _stateWithUpdatedCustomAvatar(String customAvatarPath) {
    return state.copyWith(customAvatarPath: customAvatarPath);
  }

  Stream<OperationStatus> _signUp({
    required String username,
    required String email,
    required String password,
    required AvatarType avatarType,
    required String customAvatarPath,
  }) async* {
    AvatarInterface? avatar = _getAvatar(avatarType, customAvatarPath);
    if (avatar != null) {
      Stream<HttpResult> httpResult$ = authBloc.signUp(
        username: username,
        email: email,
        password: password,
        avatar: avatar,
      );
      await for (final result in httpResult$) {
        if (result is HttpSuccess) {
          yield OperationSuccessful();
        } else if (result is HttpFailure) {
          yield OperationFailed(result.getMessage() ?? 'Unknown error...');
        }
      }
    } else {
      yield OperationFailed('Cannot get avatar model for type: $avatarType');
    }
  }

  AvatarInterface? _getAvatar(AvatarType type, String customAvatarPath) {
    if (type == AvatarType.custom) {
      return new CustomAvatar(imgFilePathFromDevice: customAvatarPath);
    } else if (type == AvatarType.red) {
      return new StandardAvatarRed();
    } else if (type == AvatarType.green) {
      return new StandardAvatarGreen();
    } else if (type == AvatarType.blue) {
      return new StandardAvatarBlue();
    }
  }
}
