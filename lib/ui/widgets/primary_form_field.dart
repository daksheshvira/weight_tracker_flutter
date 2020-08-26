import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight_tracker/ui/theme/colors.dart';

class PrimaryFormField extends StatelessWidget {
  FocusNode myFocusNode = new FocusNode();

  TextEditingController controller;
  InputDecoration decoration;
  String Function(String) validator;
  TextCapitalization textCapitalization;
  String labelText;
  bool obscureText;
  TextInputType keyboardType;
  String initialValue;
  void Function() onTap;
  int maxLines;
  int minLines;

  PrimaryFormField({
    Key key,
    this.controller,
    this.decoration,
    this.textCapitalization,
    this.validator,
    this.labelText,
    this.obscureText,
    this.keyboardType,
    this.initialValue,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      initialValue: initialValue,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      cursorColor: Theme.of(context).primaryColor,
      obscureText: obscureText ?? false,
      controller: controller,
      decoration: (decoration ?? InputDecoration()).copyWith(
        labelText: labelText,
        labelStyle:
            TextStyle(color: myFocusNode.hasFocus ? WTColors.limeGreen : Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: WTColors.limeGreen),
        ),
      ),
      validator: validator,
      onTap: onTap,
      maxLines: maxLines,
      minLines: minLines,
    );
  }
}
