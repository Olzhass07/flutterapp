final RegExp _emailRegExp = RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);

final RegExp _passwordRegExp =
    RegExp(r'^(?=.*[A-Z])(?=.*[!@#\$&*~^%]).{8,}$');

String? validateName(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) {
    return 'Please enter your name';
  }
  if (trimmed.length < 2) {
    return 'Name is too short';
  }
  return null;
}

String? validateEmail(String email) {
  final trimmed = email.trim();
  if (trimmed.isEmpty) {
    return 'Please enter your email';
  }
  if (!_emailRegExp.hasMatch(trimmed)) {
    return 'Enter a valid email';
  }
  return null;
}

String? validatePassword(String password) {
  if (password.isEmpty) {
    return 'Please enter a password';
  }
  if (!_passwordRegExp.hasMatch(password)) {
    return 'Password must be at least 8 chars, include 1 uppercase & 1 special symbol';
  }
  return null;
}

String? validateConfirmPassword(String password, String confirm) {
  if (confirm.isEmpty) {
    return 'Please confirm password';
  }
  if (password != confirm) {
    return 'Passwords do not match';
  }
  return null;
}
