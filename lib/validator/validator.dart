class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return "Ussername is required!";
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Ussername is required!";
    }
    return null;
  }

  static String? confirmPassword(String? value, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "confirm Password is required!";
    }
    if (value != confirmPassword) {
      return "password and confirm password must matched!";
    }
    return null;
  }

  static String? minLength(String? value, int length) {
    if (value == null || value.length < length) {
      return "Must be at least $length characters";
    }
    return null;
  }
}
