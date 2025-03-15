import 'package:fatcherappv2/shared/widgets/editable_info_item.dart';
import 'package:fatcherappv2/shared/widgets/collapsible_animal_item.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final String response =
        await rootBundle.loadString('assets/data/usr01.json');
    final data = await json.decode(response);
    setState(() {
      userData = data;
    });
  }

  void _updateUserData(String key, String value) {
    setState(() {
      userData![key] = value;
    });
  }

  void _addAnimal(Map<String, dynamic> animal) {
    setState(() {
      userData!['animals'].add(animal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  EditableInfoItem(
                    fieldName: 'First Name',
                    fieldValue: userData!['firstName'],
                    onSave: (value) => _updateUserData('firstName', value),
                  ),
                  SizedBox(height: 8),
                  EditableInfoItem(
                    fieldName: 'Name',
                    fieldValue: userData!['name'],
                    onSave: (value) => _updateUserData('name', value),
                  ),
                  SizedBox(height: 8),
                  EditableInfoItem(
                    fieldName: 'Phone Number',
                    fieldValue: userData!['phoneNumber'],
                    onSave: (value) => _updateUserData('phoneNumber', value),
                  ),
                  SizedBox(height: 8),
                  EditableInfoItem(
                    fieldName: 'Location',
                    fieldValue: userData!['location'],
                    onSave: (value) => _updateUserData('location', value),
                  ),
                  SizedBox(height: 16),
                  Text('Animals:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...userData!['animals'].map<Widget>((animal) {
                    return CollapsibleAnimalItem(animal: animal);
                  }).toList(),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/settings/accountSettings/addAnimal',
                          extra: _addAnimal);
                    },
                    child: Text('Add Animal'),
                  ),
                ],
              ),
            ),
    );
  }
}
