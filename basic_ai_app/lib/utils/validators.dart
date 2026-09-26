class Validators {
  static String? requiredField(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  static String? number(
    String? value,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a number';
    }

    if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    }

    return null;
  }

  static String? positiveNumber(
    String? value,
  ) {
    final error = number(value);

    if (error != null) {
      return error;
    }

    if (double.parse(value!) < 0) {
      return 'Value cannot be negative';
    }

    return null;
  }
}
