import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    this.textCapitalization = TextCapitalization.none,
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.controller,
    this.keyboardType,
    this.readOnly = false,
    this.obscureText = false,
    this.validator,
    this.textInputAction,
    this.maxLines,
    this.minLines,
    this.autofillHints,
    this.labelText,
    this.inputFormatters,
    this.onSaved,
    this.onChanged,
    this.prefixIcon,
    this.focusNode,
    this.autocorrect = false,
    this.contentPadding,
  });

  final String hintText;
  final String? labelText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;
  final String? Function(String?)? onChanged;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final bool autocorrect;
  final FocusNode? focusNode;
  final List<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      textCapitalization: textCapitalization,
      autofillHints: autofillHints,
      controller: controller,
      autocorrect: autocorrect,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      onSaved: onSaved,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: InputBorder.none,
        labelText: labelText,
        contentPadding: contentPadding ?? AppPaddings.h16,
      ),
    );
  }
}
