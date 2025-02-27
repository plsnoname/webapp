import 'package:flutter/material.dart';

class GeneralTextField extends StatefulWidget {
  final String labelText;
  final TextInputType keyboardType;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final String? initialValue;

  const GeneralTextField({
    Key? key,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.onSaved,
    this.validator,
    this.initialValue,
  }) : super(key: key);

  @override
  _GeneralTextFieldState createState() => _GeneralTextFieldState();
}

class _GeneralTextFieldState extends State<GeneralTextField> {
  FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: _isFocused ? Colors.blue : Colors.black,
          ),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          focusNode: _focusNode,
          initialValue: widget.initialValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(38.0),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: widget.keyboardType,
          onSaved: widget.onSaved,
          validator: widget.validator,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
