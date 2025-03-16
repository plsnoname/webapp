import 'package:flutter/material.dart';
import 'package:fatcherappv2/shared/widgets/unified_info_section.dart';

class ReservationHealthSection extends StatelessWidget {
  final Map<String, dynamic> healthInfo;

  const ReservationHealthSection({
    Key? key,
    required this.healthInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Health Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        UnifiedInfoSection(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          itemPadding: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          infoItems: [
            InfoItemData(
              label: 'Allergies',
              value: healthInfo['allergies'],
              crossAlignment: CrossAxisAlignment.start,
            ),
            InfoItemData(
              label: 'Medications',
              value: healthInfo['medications'],
              crossAlignment: CrossAxisAlignment.start,
            ),
            InfoItemData(
              label: 'Feeding Schedule',
              value: healthInfo['feeding_schedule'],
              crossAlignment: CrossAxisAlignment.start,
            ),
          ],
        ),
      ],
    );
  }
}
