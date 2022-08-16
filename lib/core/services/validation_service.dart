enum ValidationKey {
  username,
  email,
}

class ValidationService {
  bool checkValue(ValidationKey key, String value) {
    switch (key) {
      case ValidationKey.username:
        return this._checkUsername(value);
      case ValidationKey.email:
        return this._checkEmail(value);
    }
  }

  bool _checkUsername(String username) {
    if (username.length < 3) {
      return false;
    }
    return true;
  }

  bool _checkEmail(String email) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return false;
    }
    return true;
  }
}
