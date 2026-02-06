import 'package:flutter_test/flutter_test.dart';
import 'package:olzhasmobileproject/utils/validation.dart';

void main() {
  test('validateName returns error for empty name', () {
    expect(validateName(''), 'Please enter your name');
  });

  test('validateName returns error for short name', () {
    expect(validateName('A'), 'Name is too short');
  });

  test('validateEmail returns error for invalid email', () {
    expect(validateEmail('user.example.com'), 'Enter a valid email');
  });

  test('validatePassword returns error for missing requirements', () {
    expect(
      validatePassword('abcdefg1'),
      'Password must be at least 8 chars, include 1 uppercase & 1 special symbol',
    );
  });

  test('validateConfirmPassword returns error for mismatch', () {
    expect(
      validateConfirmPassword('Abcdef!1', 'Abcdef!2'),
      'Passwords do not match',
    );
  });

  test('validatePassword accepts strong password', () {
    expect(validatePassword('Abcdef!1'), isNull);
  });
}
