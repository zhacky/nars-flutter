import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class DropdownFormFieldInt extends StatelessWidget {
  const DropdownFormFieldInt({
    Key? key,
    required this.label,
    this.textEditingController,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.border = BorderSide.none,
    this.value,
    this.values,
  }) : super(key: key);

  final String label;
  final TextEditingController? textEditingController;
  final Function(int?)? onSaved;
  final Function(int?)? onChanged;
  final String? Function(int?)? validator;
  final int? value;
  final BorderSide border;
  final List<DropdownMenuItem<int>>? values;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
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
