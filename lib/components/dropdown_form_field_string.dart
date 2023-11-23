import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class DropdownFormFieldString extends StatelessWidget {
  const DropdownFormFieldString({
    Key? key,
    required this.label,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.border = BorderSide.none,
    this.value,
    this.values,
  }) : super(key: key);

  final String label;
  final Function(String?)? onSaved;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final String? value;
  final BorderSide border;
  final List<DropdownMenuItem<String>>? values;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      value: value,
      items: values,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding * 1.5,
          vertical: defaultPadding,
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
      ),
    );
  }
}
