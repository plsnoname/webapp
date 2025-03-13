import 'package:flutter/material.dart';
import 'package:fatcherappv2/shared/widgets/enhanced_text_field.dart';
import 'package:fatcherappv2/shared/widgets/custom_button.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const CustomSearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final verticalGap = 4.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EnhancedTextField(
                  labelText: 'Where to?',
                  onChanged: onSearch,
                  style: TextFieldStyle.material,
                  borderRadius: BorderRadius.circular(6),
                  fillColor: Colors.grey[200],
                ),
                SizedBox(height: verticalGap),
                EnhancedTextField(
                  labelText: 'What date?',
                  style: TextFieldStyle.material,
                  borderRadius: BorderRadius.circular(6),
                  fillColor: Colors.grey[200],
                ),
                SizedBox(height: verticalGap),
                EnhancedTextField(
                  labelText: 'Animals',
                  style: TextFieldStyle.material,
                  borderRadius: BorderRadius.circular(6),
                  fillColor: Colors.grey[200],
                ),
                SizedBox(height: verticalGap),
              ],
            ),
          ),
          CustomButton(
            text: 'Search',
            onPressed: () {},
            width: double.infinity,
            height: 38,
            borderRadius: 6,
          ),
        ],
      ),
    );
  }
}
