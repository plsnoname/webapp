import 'package:flutter/material.dart';
import 'dropdown_state.dart';

class GeneralDropdownField<T> extends StatefulWidget {
  final String labelText;
  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;

  const GeneralDropdownField({
    Key? key,
    required this.labelText,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  GeneralDropdownFieldState<T> createState() => GeneralDropdownFieldState<T>();
}
