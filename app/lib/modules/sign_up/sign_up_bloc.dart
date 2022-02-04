import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/auth/auth_bloc.dart';
import 'package:app/models/operation_status.dart';
import 'package:app/models/http_result.model.dart';
import 'package:app/modules/sign_up/sign_up_event.dart';
import 'package:app/modules/sign_up/sing_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpAction, SignUpState> {
  final AuthBloc authBloc;

  SignUpBloc({required this.authBloc}) : super(SignUpState());

  @override
  Stream<SignUpState> mapEventToState(SignUpAction event) async* {
    if (event is SignUpUsernameChanged) {
      yield _getStateWithUpdatedUsername(event.username);
    } else if (event is SignUpEmailChanged) {
      yield _getStateWithUpdatedEmail(event.email);
    } else if (event is SignUpPasswordChanged) {
      yield _getStateWithUpdatedPassword(event.password);
    } else if (event is SignUpPasswordConfirmationChanged) {
      yield _getStateWithUpdatedPasswordConfirmation(
        event.passwordConfirmation,
      );
    } else if (event is SignUpAvatarTypeChanged) {
      yield _getStateWithUpdatedAvatar(event.avatarType);
    } else if (event is SignUpCustomAvatarPathChanged) {
      yield _getStateWithUpdatedCustomAvatar(event.imagePath);
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

  SignUpState _getStateWithUpdatedUsername(String username) {
    return state.copyWith(username: username);
  }

  SignUpState _getStateWithUpdatedEmail(String email) {
    return state.copyWith(email: email);
  }

  SignUpState _getStateWithUpdatedPassword(String password) {
    return state.copyWith(password: password);
  }

  SignUpState _getStateWithUpdatedPasswordConfirmation(
    String passwordConfirmation,
  ) {
    return state.copyWith(passwordConfirmation: passwordConfirmation);
  }

  SignUpState _getStateWithUpdatedAvatar(AvatarType avatarType) {
    return state.copyWith(avatarType: avatarType);
  }

  SignUpState _getStateWithUpdatedCustomAvatar(String customAvatarPath) {
    return state.copyWith(customAvatarPath: customAvatarPath);
  }

  Stream<OperationStatus> _signUp({
    required String username,
    required String email,
    required String password,
    required AvatarType avatarType,
    required String customAvatarPath,
  }) async* {
    Stream<HttpResult> httpResult$ = authBloc.signUp(
      username: username,
      email: email,
      password: password,
      avatarType: avatarType,
      customAvatarPath: customAvatarPath,
    );
    await for (final result in httpResult$) {
      if (result is HttpSuccess) {
        yield OperationSuccessful();
      } else if (result is HttpFailure) {
        yield OperationFailed(result.getMessage() ?? 'Unknown error...');
      }
    }
  }
}
