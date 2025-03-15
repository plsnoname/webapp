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

    // Add scroll listener to the application
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addScrollListener();
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _addScrollListener() {
    // Listen for scroll events at the application level
    NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (_isExpanded) {
          _removeOverlay();
        }
        return false;
      },
      child: Container(),
    );
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

    // Calculate the height needed for all dropdown items
    // Assuming items are roughly 50px tall each
    final double itemHeight = 50.0;
    final double totalDropdownHeight = widget.items.length * itemHeight;

    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate space available below the field
    final double spaceBelow =
        screenSize.height - fieldOffset.dy - fieldSize.height;

    // Calculate space available above the field
    final double spaceAbove =
        fieldOffset.dy - MediaQuery.of(context).padding.top;

    final double buffer = 80.0;

    // Determine if we should show the dropdown above or below
    // Show above if there's not enough space below for all items plus buffer
    final bool showAbove = spaceBelow < (totalDropdownHeight + buffer);

    // Calculate the actual height of the dropdown (limited by available space)
    final double dropdownHeight = showAbove
        ? min(totalDropdownHeight, spaceAbove - 5)
        : min(totalDropdownHeight, spaceBelow - 5);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onPanUpdate: (details) {
                  // Close dropdown when any scroll/pan gesture is detected
                  _removeOverlay();
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              width: fieldSize.width,
              left: fieldOffset.dx,
              // Position above or below based on available space
              top: showAbove
                  ? fieldOffset.dy - dropdownHeight - 5 // 5px gap
                  : fieldOffset.dy + fieldSize.height + 5, // 5px gap
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: dropdownHeight,
                  ),
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
                  child: SingleChildScrollView(
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
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() {
        _isExpanded = false;
        _isFocused = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (_isExpanded) {
          _removeOverlay();
        }
        return false;
      },
      child: Column(
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
      ),
    );
  }
}

// Helper function to get the minimum of two values
double min(double a, double b) {
  return a < b ? a : b;
}
