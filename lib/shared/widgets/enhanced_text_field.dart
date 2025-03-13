import 'package:flutter/material.dart';

enum TextFieldStyle {
  material, // Standard Material design with floating label
  custom, // Custom style with label above field
  compact, // Compact style with smaller text and spacing
}

class EnhancedTextField extends StatefulWidget {
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final String? initialValue;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextFieldStyle style;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final bool required;
  final String? hintText;

  const EnhancedTextField({
    Key? key,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.controller,
    this.initialValue,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.style = TextFieldStyle.material,
    this.fillColor,
    this.borderRadius,
    this.required = false,
    this.hintText,
  }) : super(key: key);

  @override
  State<EnhancedTextField> createState() => _EnhancedTextFieldState();
}

class _EnhancedTextFieldState extends State<EnhancedTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
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
    return widget.style == TextFieldStyle.material
        ? _buildMaterialTextField()
        : _buildCustomTextField();
  }

  Widget _buildMaterialTextField() {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      focusNode: _focusNode,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onChanged: widget.onChanged,
      style: const TextStyle(fontSize: 14.0),
      decoration: InputDecoration(
        labelText: widget.labelText + (widget.required ? ' *' : ''),
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        isDense: true, // Makes the field height smaller
        border: OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
          borderSide: const BorderSide(width: 1),
        ),
        filled: widget.fillColor != null,
        fillColor: widget.fillColor,
      ),
    );
  }

  Widget _buildCustomTextField() {
    // Use compact mode if selected
    if (widget.style == TextFieldStyle.compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.labelText + (widget.required ? ' *' : ''),
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: _isFocused ? Colors.blue : Colors.black87,
            ),
          ),
          const SizedBox(height: 4.0),
          TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            focusNode: _focusNode,
            onSaved: widget.onSaved,
            validator: widget.validator,
            onChanged: widget.onChanged,
            style: const TextStyle(fontSize: 14.0),
            decoration: InputDecoration(
              hintText: widget.hintText,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              border: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              filled: widget.fillColor != null,
              fillColor: widget.fillColor,
            ),
          ),
        ],
      );
    }

    // Original custom style implementation
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText + (widget.required ? ' *' : ''),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: _isFocused ? Colors.blue : Colors.black,
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          focusNode: _focusNode,
          onSaved: widget.onSaved,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: widget.fillColor ?? Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(38.0),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
