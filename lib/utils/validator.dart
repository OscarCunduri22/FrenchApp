class Validator {
  final String value;
  bool _isValid = true;
  String _errorMessage = '';

  Validator(this.value);

  Validator checkEmpty() {
    if (value.isEmpty) {
      _isValid = false;
      _errorMessage = 'This field cannot be empty';
    }
    return this;
  }

  Validator checkLength(int length) {
    if (value.length < length) {
      _isValid = false;
      _errorMessage = 'Minimum length is $length characters';
    }
    return this;
  }

  Validator checkEmail() {
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      _isValid = false;
      _errorMessage = 'Enter a valid email address';
    }
    return this;
  }

  Validator checkInjection() {
    final invalidChars = RegExp(r'[\' "\\;]'");
    if (invalidChars.hasMatch(value)) {
      _isValid = false;
      _errorMessage = 'Invalid characters detected';
    }
    return this;
  }

  bool isValid() {
    return _isValid;
  }

  String errorMessage() {
    return _errorMessage;
  }
}
