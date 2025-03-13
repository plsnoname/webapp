import 'package:flutter/material.dart';
import 'package:fatcherappv2/shared/widgets/enhanced_text_field.dart';

class CheckboxListItem extends StatelessWidget {
  final String title;
  final double price;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? question;
  final String? initialAnswer; // Add this line
  final ValueChanged<String?>? onAnswerChanged;

  const CheckboxListItem({
    Key? key,
    required this.title,
    required this.price,
    required this.value,
    required this.onChanged,
    this.question,
    this.initialAnswer, // Add this line
    this.onAnswerChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(38.0),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text('$title (\$$price)'),
            trailing: GestureDetector(
              onTap: () => onChanged(!value),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                child: Icon(
                  value ? Icons.check : Icons.add,
                  color: value ? Colors.green : Colors.grey,
                ),
              ),
            ),
          ),
          if (value && question != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: EnhancedTextField(
                labelText: question!,
                initialValue: initialAnswer,
                style: TextFieldStyle.custom,
                onSaved: (value) {
                  if (onAnswerChanged != null) {
                    onAnswerChanged!(value);
                  }
                },
                onChanged: onAnswerChanged,
              ),
            ),
        ],
      ),
    );
  }
}
