import 'package:flutter/material.dart';

class ReservationSummaryItem extends StatefulWidget {
  final String label;
  final String value;

  const ReservationSummaryItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  _ReservationSummaryItemState createState() => _ReservationSummaryItemState();
}

class _ReservationSummaryItemState extends State<ReservationSummaryItem> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  String _formatLabel(String label) {
    return label
        .replaceFirst('reservation_', '')
        .replaceAll('_', ' ')
        .replaceAll('#', ': ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatLabel(widget.label),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: _isEditing ? Colors.blue[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(38.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _isEditing
                      ? TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          _controller.text,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  icon: Icon(
                    _isEditing ? Icons.check : Icons.edit,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
