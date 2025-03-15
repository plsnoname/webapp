import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fatcherappv2/shared/widgets/unified_text_field.dart';
import 'package:fatcherappv2/features/make_reservation/components/general_dropdown_field.dart';
import 'package:fatcherappv2/features/make_reservation/components/checkbox_list_item.dart';
import 'package:fatcherappv2/design_system/spacing.dart';

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
  String? selectedPaymentMethod;
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
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                  formData['type'] = value;
                });
              },
            ),
          if (selectedType == 'Other')
            UnifiedTextField(
              labelText: 'What type of animal',
              initialValue: formData['otherType'],
              style: TextFieldStyle.general,
              onChanged: (value) {
                setState(() {
                  formData['otherType'] = value;
                });
              },
              onSaved: (value) => formData['otherType'] = value,
            ),
          if (selectedType == 'Dog')
            GeneralDropdownField<String>(
              labelText: 'Breed Size',
              items: ['Small', 'Medium', 'Large'],
              value: selectedBreedSize,
              onChanged: (value) {
                setState(() {
                  selectedBreedSize = value;
                  formData['breedSize'] = value;
                });
              },
            ),
          GeneralDropdownField<String>(
            labelText: 'Gender',
            items: ['Male', 'Female'],
            value: formData['gender'],
            onChanged: (value) {
              setState(() {
                formData['gender'] = value;
              });
            },
          ),
          if (formJson!.containsKey('animalQuestions'))
            ...formJson!['animalQuestions'].map<Widget>((question) {
              return UnifiedTextField(
                labelText: question,
                initialValue: formData[question],
                style: TextFieldStyle.general,
                onChanged: (value) {
                  setState(() {
                    formData[question] = value;
                  });
                },
                onSaved: (value) {
                  setState(() {
                    formData[question] = value;
                  });
                },
              );
            }).toList(),
        ];
      case 1:
        return [
          if (formJson!.containsKey('hotelQuestions'))
            ...formJson!['hotelQuestions'].map<Widget>((question) {
              return UnifiedTextField(
                key: ValueKey(question),
                labelText: question,
                initialValue: formData[question],
                style: TextFieldStyle.general,
                onChanged: (value) {
                  setState(() {
                    formData[question] = value;
                  });
                },
                onSaved: (value) => formData[question] = value,
              );
            }).toList(),
        ];
      case 2:
        return [
          if (formJson!.containsKey('accepted_payment_methods'))
            GeneralDropdownField<String>(
              labelText: 'Payment Method',
              items: formJson!['accepted_payment_methods'].cast<String>(),
              value: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                  formData['paymentMethod'] = value;
                });
              },
            ),
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
                  setState(() {
                    formData['${option['name']}_response'] = value;
                  });
                },
              );
            }).toList(),
          ],
        ];
      case 3:
        return [
          ..._buildSection(0),
          ..._buildSection(1),
          ..._buildSection(2),
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

  bool _isSection0Valid() {
    if (selectedType == null || selectedType!.isEmpty) return false;
    if (selectedType == 'Dog' &&
        (selectedBreedSize == null || selectedBreedSize!.isEmpty)) return false;
    if (selectedType == 'Other' &&
        (formData['otherType'] == null || formData['otherType']!.isEmpty))
      return false;
    if (formJson!.containsKey('animalQuestions')) {
      for (var question in formJson!['animalQuestions']) {
        if (formData[question] == null || formData[question].isEmpty)
          return false;
      }
    }
    return true;
  }

  bool _isSection1Valid() {
    if (formJson!.containsKey('hotelQuestions')) {
      for (var question in formJson!['hotelQuestions']) {
        if (formData[question] == null || formData[question].isEmpty)
          return false;
      }
    }
    return true;
  }

  bool _isSection2Valid() {
    if (formJson!.containsKey('paymentOptions') &&
        (selectedPaymentMethod == null || selectedPaymentMethod!.isEmpty)) {
      return false;
    }
    return true;
  }

  void _nextSection() {
    if (_currentSection == 0 && !_isSection0Valid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields in this section.')),
      );
    } else if (_currentSection == 1 && !_isSection1Valid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields in this section.')),
      );
    } else {
      _formKey.currentState!.save();
      setState(() {
        _currentSection++;
      });
    }
  }

  void _goToSection(int section) {
    _formKey.currentState!.save();
    setState(() {
      _currentSection = section;
    });
  }

  void _submitForm() {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      print('Form Data: $formData');
    } else {
      // Find the first invalid field and navigate to its section
      for (int i = 0; i < 4; i++) {
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
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _goToSection(0),
                    child: Text(
                      'Step 1',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: AppSpacing.paddingVerticalXS
                          .add(AppSpacing.paddingHorizontalSM),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _isSection0Valid() ? () => _goToSection(1) : null,
                    child: Text(
                      'Step 2',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: AppSpacing.paddingVerticalXS
                          .add(AppSpacing.paddingHorizontalSM),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_isSection0Valid() && _isSection1Valid())
                        ? () => _goToSection(2)
                        : null,
                    child: Text(
                      'Step 3',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: AppSpacing.paddingVerticalXS
                          .add(AppSpacing.paddingHorizontalSM),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_isSection0Valid() &&
                            _isSection1Valid() &&
                            _isSection2Valid() &&
                            selectedPaymentMethod != null)
                        ? () => _goToSection(3)
                        : null,
                    child: Text(
                      'Summary',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: AppSpacing.paddingVerticalXS
                          .add(AppSpacing.paddingHorizontalSM),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Form(
                key: _formKey,
                onChanged: () {
                  setState(() {});
                },
                child: ListView(
                  children: [
                    ..._buildSection(_currentSection),
                    if (_currentSection == 0)
                      ElevatedButton(
                        onPressed: () {
                          if (_isSection0Valid()) {
                            _nextSection();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please complete all fields in this section.')),
                            );
                          }
                        },
                        child: Text('Next Section'),
                      ),
                    if (_currentSection == 1)
                      ElevatedButton(
                        onPressed: () {
                          if (_isSection1Valid()) {
                            _nextSection();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please complete all fields in this section.')),
                            );
                          }
                        },
                        child: Text('Next Section'),
                      ),
                    if (_currentSection == 2)
                      ElevatedButton(
                        onPressed: _nextSection,
                        child: Text('Next Section'),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            if (_currentSection == 3)
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
