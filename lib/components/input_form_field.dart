import 'package:nars/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFormField extends StatelessWidget {
  const InputFormField({
    Key? key,
    required this.label,
    this.initialValue,
    this.textEditingController,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.formats,
    this.hintText,
    this.obscureText = false,
    this.border = BorderSide.none,
    this.textInputType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction,
  }) : super(key: key);

  final String label;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? textEditingController;
  final Function(String?)? onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? formats;
  final bool obscureText;
  final BorderSide border;
  final TextInputType textInputType;
  final int minLines;
  final int maxLines;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      controller: textEditingController,
      initialValue: initialValue,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      inputFormatters: formats,
      minLines: minLines,
      maxLines: maxLines,
      obscureText: obscureText,
      keyboardType: textInputType,
      // maxLength: 30,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding * 1.5,
          vertical: defaultPadding * 1.1,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: border,
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kPrimaryColor, width: 2),
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        // icon: Text(''),
        // border: InputBorder.none,
      ),
    );
  }
}
