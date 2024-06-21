class Validator {
  final String value;
  bool _isValid = true;

  Validator(this.value);

  Validator checkEmpty() {
    if (value.isEmpty) {
      _isValid = false;
    }
    return this;
  }

  Validator checkLength(int length) {
    if (value.length < length) {
      _isValid = false;
    }
    return this;
  }

  Validator checkEmail() {
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      _isValid = false;
    }
    return this;
  }

  Validator checkInjection() {
    final invalidChars = RegExp(r'[\' "\\;]'");
    if (invalidChars.hasMatch(value)) {
      _isValid = false;
    }
    return this;
  }

  bool isValid() {
    return _isValid;
  }
}
