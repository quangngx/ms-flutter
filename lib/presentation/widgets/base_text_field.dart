import 'package:flutter/material.dart';
import 'package:masterstudy_app/theme/app_color.dart';

/// Base Text Form Field widget
/// Use in SignUpScreen, SignInScreen
class BaseTextField extends StatelessWidget {
  const BaseTextField({
    super.key,
    required this.controller,
    this.enabled,
    required this.labelText,
    this.helperText,
    this.hintText,
    required this.hasFocus,
    this.validator,
    this.suffixIcon,
    this.obscureText,
    this.autoFocus,
    this.errorText,
    this.readOnly,
    this.maxLines,
    this.textCapitalization,
  });

  final TextEditingController controller;
  final bool? enabled;
  final String labelText;
  final String? helperText;
  final String? hintText;
  final bool hasFocus;
  final bool? obscureText;
  final String? Function(String? val)? validator;
  final Widget? suffixIcon;
  final bool? autoFocus;
  final String? errorText;
  final bool? readOnly;
  final int? maxLines;
  final TextCapitalization? textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      autofocus: autoFocus ?? false,
      obscureText: obscureText ?? false,
      cursorColor: ColorApp.mainColor,
      readOnly: readOnly ?? false,
      maxLines: maxLines ?? 1,
      textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        errorMaxLines: 2,
        labelText: labelText,
        helperText: helperText,
        filled: true,
        labelStyle: TextStyle(
          color: hasFocus ? Colors.red : Colors.black,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorApp.mainColor,
            width: 2,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
