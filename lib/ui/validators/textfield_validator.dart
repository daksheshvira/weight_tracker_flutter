class TextFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Field cannot be empty' : null;
  }
}
