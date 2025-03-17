import 'package:flutter/material.dart';
import 'dropdown_utils.dart';

class DropdownOverlayBuilder<T> {
  final Function() removeOverlay;
  final Function(T) onItemSelected;

  DropdownOverlayBuilder({
    required this.removeOverlay,
    required this.onItemSelected,
  });

  OverlayEntry buildOverlay({
    required BuildContext context,
    required GlobalKey fieldKey,
    required List<T> items,
  }) {
    RenderBox renderBox =
        fieldKey.currentContext!.findRenderObject() as RenderBox;
    Offset fieldOffset = renderBox.localToGlobal(Offset.zero);
    Size fieldSize = renderBox.size;

    // Calculate the height needed for all dropdown items
    final double itemHeight = 50.0;
    final double totalDropdownHeight = items.length * itemHeight;

    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate space available below and above
    final double spaceBelow =
        screenSize.height - fieldOffset.dy - fieldSize.height;
    final double spaceAbove =
        fieldOffset.dy - MediaQuery.of(context).padding.top;

    final double buffer = 80.0;

    // Determine if we should show the dropdown above or below
    final bool showAbove = spaceBelow < (totalDropdownHeight + buffer);

    // Calculate the actual height of the dropdown
    final double dropdownHeight = showAbove
        ? min(totalDropdownHeight, spaceAbove - 5)
        : min(totalDropdownHeight, spaceBelow - 5);

    return OverlayEntry(
      builder: (context) => _buildOverlayContent(
        context,
        items,
        fieldOffset,
        fieldSize,
        dropdownHeight,
        showAbove,
      ),
    );
  }

  Widget _buildOverlayContent(
    BuildContext context,
    List<T> items,
    Offset fieldOffset,
    Size fieldSize,
    double dropdownHeight,
    bool showAbove,
  ) {
    return GestureDetector(
      onTap: removeOverlay,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: (_) => removeOverlay(),
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            width: fieldSize.width,
            left: fieldOffset.dx,
            top: showAbove
                ? fieldOffset.dy - dropdownHeight - 5
                : fieldOffset.dy + fieldSize.height + 5,
            child: _buildDropdownList(items, dropdownHeight),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownList(List<T> items, double dropdownHeight) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxHeight: dropdownHeight),
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
            children:
                items.map((item) => _buildDropdownItem(item, items)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(T item, List<T> items) {
    return GestureDetector(
      onTap: () => onItemSelected(item),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: items.last != item
              ? Border(bottom: BorderSide(color: Colors.grey[300]!))
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
    );
  }
}
