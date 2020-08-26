class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email cannot be empty' : null;
  }
}
