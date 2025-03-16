import 'package:flutter/material.dart';

class ReviewActionButtons extends StatelessWidget {
  final bool isSubmitEnabled;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final BuildContext context;

  const ReviewActionButtons({
    Key? key,
    required this.isSubmitEnabled,
    required this.onCancel,
    required this.onSubmit,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onCancel,
          child: Text('CANCEL'),
        ),
        SizedBox(width: 8.0),
        ElevatedButton(
          onPressed: isSubmitEnabled ? onSubmit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            disabledBackgroundColor: Colors.grey,
          ),
          child: Text('SUBMIT'),
        ),
      ],
    );
  }
}
