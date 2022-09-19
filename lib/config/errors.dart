enum AuthErrorCode {
  invalidEmail,
  wrongPassword,
  userNotFound,
  emailAlreadyInUse,
  unknown,
}

enum NetworkErrorCode {
  lossOfConnection,
}

enum UserErrorCode { userNotFound, updateFailure }

enum BookErrorCode {
  newCurrentPageIsTooHigh,
}
