import 'package:flutter/material.dart';
import 'unified_text_field.dart';

class EditableInfoItem extends StatefulWidget {
  final String fieldName;
  final String fieldValue;
  final ValueChanged<String> onSave;

  const EditableInfoItem({
    Key? key,
    required this.fieldName,
    required this.fieldValue,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditableInfoItemState createState() => _EditableInfoItemState();
}

class _EditableInfoItemState extends State<EditableInfoItem> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.fieldValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.fieldName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _isEditing
                  ? UnifiedTextField(
                      controller: _controller,
                      labelText:
                          '', // Empty label since we already have the field name above
                      hintText: 'Enter ${widget.fieldName}',
                      style: TextFieldStyle.material,
                    )
                  : Text(widget.fieldValue, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        IconButton(
          icon: Icon(_isEditing ? Icons.check : Icons.edit),
          onPressed: () {
            if (_isEditing) {
              widget.onSave(_controller.text);
            }
            setState(() {
              _isEditing = !_isEditing;
            });
          },
        ),
      ],
    );
  }
}
