import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveData(String label, String value, String type) async {
    final key = 'reservation_${type}_$label';
    await _storage.write(key: key, value: value);
  }

  Future<String?> getData(String label, String type) async {
    final key = 'reservation_${type}_$label';
    return await _storage.read(key: key);
  }

  Future<void> deleteData(String label, String type) async {
    final key = 'reservation_${type}_$label';
    await _storage.delete(key: key);
  }

  Future<Map<String, String>> getAllReservationData() async {
    final allData = await _storage.readAll();
    final filteredData = allData
      ..removeWhere((key, value) => !key.startsWith('reservation_'));
    return filteredData;
  }

  Future<void> clearAllReservationData() async {
    final allData = await _storage.readAll();
    for (var key in allData.keys) {
      if (key.startsWith('reservation_')) {
        await _storage.delete(key: key);
      }
    }
  }

  Future<void> saveKeyWithoutValue(String label, String type) async {
    final key = 'reservation_${type}_$label';
    await _storage.write(key: key, value: '');
  }

  Future<void> updateValue(String label, String type, String newValue) async {
    final key = 'reservation_${type}_$label';
    await _storage.write(key: key, value: newValue);
  }

  Future<void> saveDropdownData(
      String label, List<String> items, String selectedValue) async {
    final key = 'reservation_dropdown_$label';
    final value = items.join('|') + '||' + selectedValue;
    await _storage.write(key: key, value: value);
  }

  Future<String?> getDropdownData(String label) async {
    final key = 'reservation_dropdown_$label';
    return await _storage.read(key: key);
  }
}
