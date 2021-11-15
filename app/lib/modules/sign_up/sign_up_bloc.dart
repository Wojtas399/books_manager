import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/form_submission_status.dart';
import 'package:app/modules/sign_up/sign_up_event.dart';
import 'package:app/modules/sign_up/sing_up_state.dart';
import 'package:app/repositories/auth/auth_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthInterface authInterface;

  SignUpBloc({required this.authInterface}) : super(SignUpState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpUsernameChanged) {
      yield state.copyWith(
        username: event.username,
        formStatus: InitialFormStatus(),
      );
    } else if (event is SignUpEmailChanged) {
      yield state.copyWith(
        email: event.email,
        formStatus: InitialFormStatus(),
      );
    } else if (event is SignUpPasswordChanged) {
      yield state.copyWith(
        password: event.password,
        formStatus: InitialFormStatus(),
      );
    } else if (event is SignUpPasswordConfirmationChanged) {
      yield state.copyWith(
        passwordConfirmation: event.passwordConfirmation,
        formStatus: InitialFormStatus(),
      );
    } else if (event is SignUpAvatarChanged) {
      yield state.copyWith(
        basicAvatar: event.type,
        formStatus: InitialFormStatus(),
      );
    } else if (event is SignUpCustomAvatarChanged) {
      yield state.copyWith(
        customAvatar: event.image,
        formStatus: InitialFormStatus(),
      );
    } else if (event is SignUpSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
      String avatar = '';
      switch (event.chosenAvatar) {
        case AvatarType.red: avatar = 'RedBook.png';
        break;
        case AvatarType.green: avatar = 'GreenBook.png';
        break;
        case AvatarType.blue: avatar = 'BlueBook.png';
        break;
        case AvatarType.custom: avatar = event.customAvatar;
        break;
      }
      await authInterface.signUp(
        username: event.username,
        email: event.email,
        password: event.password,
        avatar: avatar,
      );
      yield state.copyWith(formStatus: SubmissionSuccess());
    }
  }
}
