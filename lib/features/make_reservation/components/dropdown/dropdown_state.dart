import 'package:flutter/material.dart';
import 'dropdown_widget.dart';
import 'dropdown_overlay_builder.dart';
//import 'dropdown_utils.dart';

class GeneralDropdownFieldState<T> extends State<GeneralDropdownField<T>> {
  T? _selectedValue;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  bool _isExpanded = false;
  bool _isFocused = false;
  late DropdownOverlayBuilder<T> _overlayBuilder;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
    _overlayBuilder = DropdownOverlayBuilder<T>(
      removeOverlay: _removeOverlay,
      onItemSelected: _handleItemSelected,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addScrollListener();
    });
  }

  void _addScrollListener() {
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

  void _handleItemSelected(T item) {
    setState(() {
      _selectedValue = item;
      widget.onChanged?.call(item);
    });
    _removeOverlay();
  }

  void _toggleDropdown() {
    if (_isExpanded) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _overlayBuilder.buildOverlay(
      context: context,
      fieldKey: _fieldKey,
      items: widget.items,
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
  void dispose() {
    _removeOverlay();
    super.dispose();
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
      child: _buildDropdownField(),
    );
  }

  Widget _buildDropdownField() {
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
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            key: _fieldKey,
            onTap: _toggleDropdown,
            child: _buildDropdownButton(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      height: 56.0,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedValue?.toString() ?? 'Select an option',
            style: TextStyle(
              color: _selectedValue == null ? Colors.grey : Colors.black,
              fontSize: 16.0,
            ),
          ),
          Icon(
            _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
