import 'package:flutter/material.dart';

enum TextFieldStyle {
  material, // Standard Material design with floating label
  custom, // Custom style with label above field
  compact, // Compact style with smaller text and spacing
  general, // Style matching the GeneralTextField component
}

class UnifiedTextField extends StatefulWidget {
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
  final int? maxLines;
  final EdgeInsets? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;

  const UnifiedTextField({
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
    this.maxLines = 1,
    this.contentPadding,
    this.textStyle,
    this.labelStyle,
  }) : super(key: key);

  // Add a factory constructor to support easy migration from GeneralTextField
  factory UnifiedTextField.general({
    Key? key,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    String? initialValue,
    ValueChanged<String>? onChanged,
  }) {
    return UnifiedTextField(
      key: key,
      labelText: labelText,
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      onChanged: onChanged,
      style: TextFieldStyle.general,
    );
  }

  // Add a factory constructor to support easy migration from EnhancedTextField
  factory UnifiedTextField.enhanced({
    Key? key,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    TextEditingController? controller,
    String? initialValue,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    TextFieldStyle style = TextFieldStyle.material,
    Color? fillColor,
    BorderRadius? borderRadius,
    bool required = false,
    String? hintText,
    int? maxLines,
    EdgeInsets? contentPadding,
    TextStyle? textStyle,
  }) {
    return UnifiedTextField(
      key: key,
      labelText: labelText,
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      initialValue: initialValue,
      onSaved: onSaved,
      validator: validator,
      onChanged: onChanged,
      style: style,
      fillColor: fillColor,
      borderRadius: borderRadius,
      required: required,
      hintText: hintText,
      maxLines: maxLines,
      contentPadding: contentPadding,
      textStyle: textStyle,
    );
  }

  @override
  State<UnifiedTextField> createState() => _UnifiedTextFieldState();
}

class _UnifiedTextFieldState extends State<UnifiedTextField> {
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
    switch (widget.style) {
      case TextFieldStyle.material:
        return _buildMaterialTextField();
      case TextFieldStyle.compact:
        return _buildCompactTextField();
      case TextFieldStyle.general:
        return _buildGeneralTextField();
      case TextFieldStyle.custom:
      default:
        return _buildCustomTextField();
    }
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
      maxLines: widget.maxLines,
      style: widget.textStyle ?? const TextStyle(fontSize: 14.0),
      decoration: InputDecoration(
        labelText: widget.labelText + (widget.required ? ' *' : ''),
        hintText: widget.hintText,
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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

  Widget _buildCompactTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.labelText + (widget.required ? ' *' : ''),
          style: widget.labelStyle ??
              TextStyle(
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
          maxLines: widget.maxLines,
          style: widget.textStyle ?? const TextStyle(fontSize: 14.0),
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: widget.contentPadding ??
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

  Widget _buildCustomTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText + (widget.required ? ' *' : ''),
          style: widget.labelStyle ??
              TextStyle(
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
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: widget.fillColor ?? Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(38.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: widget.contentPadding,
          ),
          style: widget.textStyle ??
              const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildGeneralTextField() {
    // This mimics the GeneralTextField component style
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: widget.labelStyle ??
              TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: _isFocused ? Colors.blue : Colors.black,
              ),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          onSaved: widget.onSaved,
          validator: widget.validator,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: widget.fillColor ?? Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(38.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: widget.contentPadding,
          ),
          style: widget.textStyle ??
              TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
