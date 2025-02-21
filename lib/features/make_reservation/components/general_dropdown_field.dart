import 'package:flutter/material.dart';

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
  _GeneralDropdownFieldState<T> createState() =>
      _GeneralDropdownFieldState<T>();
}

class _GeneralDropdownFieldState<T> extends State<GeneralDropdownField<T>> {
  T? _selectedValue;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  bool _isExpanded = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  void _toggleDropdown() {
    if (_isExpanded) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    RenderBox renderBox =
        _fieldKey.currentContext!.findRenderObject() as RenderBox;
    Offset fieldOffset = renderBox.localToGlobal(Offset.zero);
    Size fieldSize = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              width: fieldSize.width,
              left: fieldOffset.dx,
              top:
                  fieldOffset.dy + fieldSize.height + 5, // Position below field
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(38.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: widget.items
                        .map(
                          (item) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedValue = item;
                                widget.onChanged?.call(item);
                              });
                              _removeOverlay();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                border: widget.items.last != item
                                    ? Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[300]!))
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.person, color: Colors.grey[600]),
                                  SizedBox(width: 10),
                                  Text(
                                    item.toString(),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isExpanded = true;
      _isFocused = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isExpanded = false;
      _isFocused = false;
    });
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

        // Dropdown Field
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            key: _fieldKey,
            onTap: _toggleDropdown,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              height: 56.0, // Set the height to match the text field
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
                // Remove the border
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedValue?.toString() ?? 'Select an option',
                    style: TextStyle(
                      color:
                          _selectedValue == null ? Colors.grey : Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
