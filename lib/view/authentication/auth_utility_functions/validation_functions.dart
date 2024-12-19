class ValidationFunctions {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty || email.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!email.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null ||
        password.isEmpty ||
        password.trim().isEmpty ||
        password.length < 6) {
      return 'Please enter your password';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
