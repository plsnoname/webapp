import 'package:fatcherappv2/features/authentication/login_guard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../components/general_text_field.dart';
import '../components/general_dropdown_field.dart';

class AnimalFormPage extends StatefulWidget {
  final String hotelName;
  final VoidCallback onNext;

  const AnimalFormPage(
      {Key? key, required this.hotelName, required this.onNext})
      : super(key: key);

  @override
  _AnimalFormPageState createState() => _AnimalFormPageState();
}

class _AnimalFormPageState extends State<AnimalFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _animalType = 'Dog';
  String? _dogSize;
  String? _animalName;
  String? _otherAnimal;
  String? _age;
  String? _sex;

  Future<void> _saveToStorage() async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'reservation_Animal Type', value: _animalType);
    await storage.write(key: 'reservation_Dog Size', value: _dogSize);
    await storage.write(key: 'reservation_Animal Name', value: _animalName);
    await storage.write(key: 'reservation_Other Animal', value: _otherAnimal);
    await storage.write(key: 'reservation_Age', value: _age);
    await storage.write(key: 'reservation_Sex', value: _sex);
  }

  @override
  Widget build(BuildContext context) {
    return LoginGuard(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.hotelName),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GeneralDropdownField<String>(
                  labelText: 'Type of Animal',
                  items: ['Dog', 'Cat', 'Other'],
                  value: _animalType,
                  onChanged: (value) {
                    setState(() {
                      _animalType = value!;
                      _dogSize = null;
                      _otherAnimal = null;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select an animal type' : null,
                ),
                if (_animalType == 'Dog')
                  GeneralDropdownField<String>(
                    labelText: 'Dog Size',
                    items: ['Small', 'Medium', 'Large'],
                    value: _dogSize,
                    onChanged: (value) {
                      setState(() {
                        _dogSize = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a dog size' : null,
                  ),
                if (_animalType == 'Other')
                  GeneralTextField(
                    labelText: 'Specify Other Animal',
                    onSaved: (value) {
                      _otherAnimal = value;
                    },
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please specify the animal'
                        : null,
                  ),
                GeneralTextField(
                  labelText: 'Animal Name',
                  onSaved: (value) {
                    _animalName = value;
                  },
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter the animal name'
                      : null,
                ),
                GeneralTextField(
                  labelText: 'Age',
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _age = value;
                  },
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter the age'
                      : null,
                ),
                GeneralDropdownField<String>(
                  labelText: 'Sex',
                  items: ['Male', 'Female'],
                  value: _sex,
                  onChanged: (value) {
                    setState(() {
                      _sex = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select the sex' : null,
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await _saveToStorage();
                        // Navigate to the next page or perform other actions
                        print('Animal Type: $_animalType');
                        print('Dog Size: $_dogSize');
                        print('Animal Name: $_animalName');
                        print('Other Animal: $_otherAnimal');
                        print('Age: $_age');
                        print('Sex: $_sex');
                        widget.onNext();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(38.0),
                      ),
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      'Next',
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
      ),
    );
  }
}
