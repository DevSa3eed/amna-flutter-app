/// Validation service for form inputs
class ValidationService {
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    if (value.length > 50) {
      return 'Password must be less than 50 characters';
    }

    return null;
  }

  /// Validate confirm password
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate name (first name, last name, etc.)
  static String? validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters long';
    }

    if (value.trim().length > 50) {
      return '$fieldName must be less than 50 characters';
    }

    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return '$fieldName can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number must be less than 15 digits';
    }

    return null;
  }

  /// Validate username
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }

    if (value.length > 20) {
      return 'Username must be less than 20 characters';
    }

    // Check for valid characters (letters, numbers, underscores)
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  /// Validate age
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }

    if (age < 1) {
      return 'Age must be at least 1';
    }

    if (age > 120) {
      return 'Age must be less than 120';
    }

    return null;
  }

  /// Validate description or text area
  static String? validateDescription(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.trim().length < 10) {
      return '$fieldName must be at least 10 characters long';
    }

    if (value.trim().length > 500) {
      return '$fieldName must be less than 500 characters';
    }

    return null;
  }

  /// Validate URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }

    final urlRegex = RegExp(
        r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$');

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Validate OTP code
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP code is required';
    }

    if (value.length != 6) {
      return 'OTP code must be 6 digits';
    }

    final otpRegex = RegExp(r'^\d{6}$');
    if (!otpRegex.hasMatch(value)) {
      return 'OTP code must contain only numbers';
    }

    return null;
  }

  /// Validate meeting duration
  static String? validateDuration(String? value) {
    if (value == null || value.isEmpty) {
      return 'Duration is required';
    }

    final duration = int.tryParse(value);
    if (duration == null) {
      return 'Please enter a valid duration';
    }

    if (duration < 15) {
      return 'Duration must be at least 15 minutes';
    }

    if (duration > 180) {
      return 'Duration must be less than 180 minutes';
    }

    return null;
  }

  /// Validate file size (for image uploads)
  static String? validateFileSize(int? fileSizeInBytes, int maxSizeInMB) {
    if (fileSizeInBytes == null) {
      return 'File size is required';
    }

    final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    if (fileSizeInBytes > maxSizeInBytes) {
      return 'File size must be less than ${maxSizeInMB}MB';
    }

    return null;
  }

  /// Validate file type (for image uploads)
  static String? validateFileType(
      String? fileName, List<String> allowedExtensions) {
    if (fileName == null || fileName.isEmpty) {
      return 'File name is required';
    }

    final extension = fileName.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      return 'File type not supported. Allowed types: ${allowedExtensions.join(', ')}';
    }

    return null;
  }

  /// Validate multiple fields at once
  static Map<String, String?> validateFields(Map<String, String?> fields) {
    final errors = <String, String?>{};

    for (final entry in fields.entries) {
      final fieldName = entry.key;
      final value = entry.value;

      switch (fieldName.toLowerCase()) {
        case 'email':
          errors[fieldName] = validateEmail(value);
          break;
        case 'password':
          errors[fieldName] = validatePassword(value);
          break;
        case 'confirmpassword':
        case 'confirm_password':
          // This would need the original password to compare
          errors[fieldName] = validateRequired(value, 'Confirm Password');
          break;
        case 'firstname':
        case 'first_name':
          errors[fieldName] = validateName(value, 'First Name');
          break;
        case 'lastname':
        case 'last_name':
          errors[fieldName] = validateName(value, 'Last Name');
          break;
        case 'username':
          errors[fieldName] = validateUsername(value);
          break;
        case 'phone':
          errors[fieldName] = validatePhone(value);
          break;
        case 'age':
          errors[fieldName] = validateAge(value);
          break;
        case 'description':
          errors[fieldName] = validateDescription(value, 'Description');
          break;
        case 'otp':
          errors[fieldName] = validateOTP(value);
          break;
        default:
          errors[fieldName] = validateRequired(value, fieldName);
      }
    }

    return errors;
  }
}
