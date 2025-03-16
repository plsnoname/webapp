import 'package:flutter/material.dart';
import 'package:fatcherappv2/shared/widgets/unified_info_section.dart';

class ReservationBasicInfoSection extends StatelessWidget {
  final Map<String, dynamic> reservation;

  const ReservationBasicInfoSection({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedInfoSection(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      itemPadding: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      infoItems: [
        InfoItemData(
          label: 'Hotel',
          value: reservation['hotel_name'],
          crossAlignment: CrossAxisAlignment.start,
        ),
        InfoItemData(
          label: 'Animal',
          value:
              '${reservation['animal']['name']} (${reservation['animal']['type']})',
          crossAlignment: CrossAxisAlignment.start,
        ),
        InfoItemData(
          label: 'Breed',
          value: reservation['animal']['breed'],
          crossAlignment: CrossAxisAlignment.start,
        ),
        InfoItemData(
          label: 'Age',
          value: reservation['animal']['age'],
          crossAlignment: CrossAxisAlignment.start,
        ),
        InfoItemData(
          label: 'Date',
          value: reservation['date'],
          crossAlignment: CrossAxisAlignment.start,
        ),
        InfoItemData(
          label: 'Address',
          value: reservation['address'],
          crossAlignment: CrossAxisAlignment.start,
        ),
        InfoItemData(
          label: 'Status',
          value: reservation['status'],
          valueStyle: const TextStyle(color: Colors.redAccent),
          crossAlignment: CrossAxisAlignment.start,
        ),
      ],
    );
  }
}
