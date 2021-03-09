

class MockAuthService {
  final email = 'test@real.com';
  final password = 'sup';

  String enteredEmail = '';
  String enteredPassword = '';

  bool get hasUser {
    return email == enteredEmail && password == enteredPassword;
  }

  void emailPasswordLogin(email, password) {
    enteredEmail = email;
    enteredPassword = password;
  }
}