import 'package:flutter/material.dart';
import '../components/storage_helper.dart';
import '../components/general_text_field.dart';
import '../components/general_dropdown_field.dart';
import '../components/checkbox_list_item.dart';

class ReservationSummary extends StatefulWidget {
  final Map<String, dynamic> reservationData;

  const ReservationSummary({Key? key, required this.reservationData})
      : super(key: key);

  @override
  _ReservationSummaryState createState() => _ReservationSummaryState();
}

class _ReservationSummaryState extends State<ReservationSummary> {
  final _formKey = GlobalKey<FormState>();
  final StorageHelper _storageHelper = StorageHelper();
  Map<String, String> _data = {};

  @override
  void initState() {
    super.initState();
    _loadReservationData();
  }

  Future<void> _loadReservationData() async {
    final data = await _storageHelper.getAllReservationData();
    setState(() {
      _data = data;
    });
  }

  Future<void> _clearReservationData() async {
    await _storageHelper.clearAllReservationData();
  }

  List<MapEntry<String, String>> _getOrderedEntries() {
    final animalFormKeys = [
      'reservation_dropdown_Animal Type',
      'reservation_dropdown_Dog Size',
      'reservation_text_Animal Name',
      'reservation_text_Other Animal',
      'reservation_text_Age',
      'reservation_dropdown_Sex',
    ];

    final animalFormStageTwoKeys = _data.keys
        .where((key) =>
            key.startsWith('reservation_text_') &&
            !animalFormKeys.contains(key))
        .toList();

    final extrasSelectorKeys = _data.keys
        .where((key) =>
            key.startsWith('reservation_checkbox_') ||
            key.startsWith('reservation_dropdown_Payment Method'))
        .toList();

    final orderedKeys = [
      ...animalFormKeys,
      ...animalFormStageTwoKeys,
      ...extrasSelectorKeys,
    ];

    return orderedKeys
        .where((key) => _data.containsKey(key))
        .map((key) => MapEntry(key, _data[key]!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Summary'),
        centerTitle: true,
      ),
      body: _data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text(
                      'Reservation Summary',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    ..._getOrderedEntries().map((entry) {
                      final keyParts = entry.key.split('_');
                      final type = keyParts[1];
                      final label = keyParts.sublist(2).join(' ');

                      switch (type) {
                        case 'text':
                          return GeneralTextField(
                            labelText: label,
                            initialValue: entry.value,
                            onSaved: (value) async {
                              await _storageHelper.updateValue(
                                  label, 'text', value ?? '');
                            },
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Please enter a value'
                                    : null,
                          );
                        case 'dropdown':
                          final items = entry.value.split('|');
                          final selectedValue = items.removeLast();
                          return GeneralDropdownField<String>(
                            labelText: label,
                            items: items,
                            value: selectedValue,
                            onChanged: (value) async {
                              setState(() {
                                _data[entry.key] =
                                    items.join('|') + '||' + value!;
                              });
                              await _storageHelper.updateValue(
                                  label, 'dropdown', value!);
                            },
                          );
                        case 'checkbox':
                          final isChecked = entry.value == 'true';
                          return CheckboxListItem(
                            title: label,
                            price: 0.0,
                            value: isChecked,
                            onChanged: (value) async {
                              setState(() {
                                _data[entry.key] = value.toString();
                              });
                              await _storageHelper.updateValue(
                                  label, 'checkbox', value.toString());
                            },
                          );
                        default:
                          return Container();
                      }
                    }).toList(),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await _clearReservationData();
                            // Perform final submission or navigation
                            print('Final submission');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(38.0),
                          ),
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Confirm Reservation',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
