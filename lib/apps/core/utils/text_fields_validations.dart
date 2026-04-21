class TextFieldsValidations {
  static String? validateNameField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@_?#%])[A-Za-z\d@_?#%]{8,}$',
    );
    if (!passwordRegex.hasMatch(value)) {
      return 'Password must contain at least one letter and one number';
    }
    return null;
  }

  static bool isPhoneNumberStartWithZero(String phoneNumber) {
    return phoneNumber.startsWith('0');
  }

  // validate phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Ensure only digits are present
    final phoneRegex = RegExp(r'^[0-9]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Phone number must contain only digits';
    }

    if (value.startsWith('0')) {
      // Exact check for 11 digits when starting with 0
      if (value.length != 11) {
        return 'Phone number must be exactly 11 digits when starting with 0';
      }
    } else {
      // Exact check for 10 digits when not starting with 0
      if (value.length != 10) {
        return 'Phone number must be exactly 10 digits';
      }
    }

    return null;
  }
}
