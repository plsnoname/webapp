import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fatcherappv2/features/make_reservation/components/general_text_field.dart';
import 'package:fatcherappv2/features/make_reservation/components/general_dropdown_field.dart';
import 'package:fatcherappv2/features/make_reservation/components/checkbox_list_item.dart';

class DynamicFormScreen extends StatefulWidget {
  final String hotelName;

  DynamicFormScreen({required this.hotelName});

  @override
  _DynamicFormScreenState createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  Map<String, dynamic>? formJson;
  bool _isLoading = true;
  String? _errorMessage;
  String? selectedType;
  String? selectedBreedSize;
  int _currentSection = 0;

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/res_form.json');
      setState(() {
        formJson = jsonDecode(jsonString);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load form data: $e';
        _isLoading = false;
      });
    }
  }

  List<Widget> _buildSection(int section) {
    switch (section) {
      case 0:
        return [
          if (formJson!.containsKey('type'))
            GeneralDropdownField<String>(
              labelText: 'Type',
              items: (formJson!['type'] as String).split(', '),
              value: selectedType,
              onChanged: (value) => setState(() {
                selectedType = value;
                formData['type'] = value;
              }),
            ),
          if (selectedType == 'Other')
            GeneralTextField(
              labelText: 'What type of animal',
              initialValue: formData['otherType'],
              onSaved: (value) => formData['otherType'] = value,
            ),
          if (selectedType == 'Dog')
            GeneralDropdownField<String>(
              labelText: 'Breed Size',
              items: ['Small', 'Medium', 'Large'],
              value: selectedBreedSize,
              onChanged: (value) => setState(() {
                selectedBreedSize = value;
                formData['breedSize'] = value;
              }),
            ),
          GeneralDropdownField<String>(
            labelText: 'Gender',
            items: ['Male', 'Female'],
            value: formData['gender'],
            onChanged: (value) => setState(() {
              formData['gender'] = value;
            }),
          ),
          if (formJson!.containsKey('animalQuestions'))
            ...formJson!['animalQuestions'].map<Widget>((question) {
              return GeneralTextField(
                labelText: question,
                initialValue: formData[question],
                onSaved: (value) => formData[question] = value,
              );
            }).toList(),
        ];
      case 1:
        return [
          if (formJson!.containsKey('hotelQuestions'))
            ...formJson!['hotelQuestions'].map<Widget>((question) {
              return GeneralTextField(
                labelText: question,
                initialValue: formData[question],
                onSaved: (value) => formData[question] = value,
              );
            }).toList(),
        ];
      case 2:
        return [
          if (formJson!.containsKey('extra_options')) ...[
            Text('Extras:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ...formJson!['extra_options'].map<Widget>((option) {
              return CheckboxListItem(
                title: option['name'],
                price: option['price'],
                value: formData[option['name']] ?? false,
                onChanged: (value) {
                  setState(() {
                    formData[option['name']] = value;
                  });
                },
                question: option['question'],
                initialAnswer: formData['${option['name']}_response'],
                onAnswerChanged: (value) {
                  formData['${option['name']}_response'] = value;
                },
              );
            }).toList(),
          ],
        ];
      default:
        return [];
    }
  }

  bool _isCurrentSectionValid() {
    final currentFormState = _formKey.currentState;
    if (currentFormState != null) {
      return currentFormState.validate();
    }
    return false;
  }

  void _nextSection() {
    if (_isCurrentSectionValid()) {
      _formKey.currentState!.save();
      setState(() {
        _currentSection++;
      });
    }
  }

  void _goToSection(int section) {
    if (section <= _currentSection) {
      _formKey.currentState!.save();
      setState(() {
        _currentSection = section;
      });
    }
  }

  void _submitForm() {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      print('Form Data: $formData');
    } else {
      // Find the first invalid field and navigate to its section
      for (int i = 0; i < 3; i++) {
        setState(() {
          _currentSection = i;
        });
        if (!_isCurrentSectionValid()) {
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(_errorMessage!)),
      );
    }

    if (formJson == null || formJson!.isEmpty) {
      return Scaffold(
        body: Center(child: Text('Form data is empty or invalid')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _goToSection(0),
                  child: Text('Section 1'),
                ),
                ElevatedButton(
                  onPressed: () => _goToSection(1),
                  child: Text('Section 2'),
                ),
                ElevatedButton(
                  onPressed: () => _goToSection(2),
                  child: Text('Section 3'),
                ),
              ],
            ),
            Expanded(
              child: Form(
                key: _formKey,
                onChanged: () => setState(() {}),
                child: ListView(
                  children: [
                    ..._buildSection(_currentSection),
                    if (_currentSection < 2)
                      ElevatedButton(
                        onPressed: _nextSection,
                        child: Text('Next Section'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isCurrentSectionValid()
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_currentSection == 2)
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
          ],
        ),
      ),
    );
  }
}
