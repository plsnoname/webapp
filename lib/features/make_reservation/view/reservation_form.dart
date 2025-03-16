import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:fatcherappv2/providers/user_profile_provider.dart';
import 'package:fatcherappv2/shared/widgets/unified_text_field.dart';
import 'package:fatcherappv2/features/make_reservation/components/general_dropdown_field.dart';
import 'package:fatcherappv2/features/make_reservation/components/checkbox_list_item.dart';
import 'package:fatcherappv2/design_system/spacing.dart';
import 'package:fatcherappv2/shared/widgets/collapsible_animal_item.dart';

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

  // Pet selection related variables
  List<Map<String, dynamic>> _userPets = [];
  Map<String, dynamic>? _selectedPet;
  bool _isManualEntryExpanded = true;

  @override
  void initState() {
    super.initState();
    _loadJsonData();
    _loadUserPets();
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

  Future<void> _loadUserPets() async {
    try {
      // Try loading from UserProfileProvider first
      final userProfileProvider =
          Provider.of<UserProfileProvider>(context, listen: false);

      if (!userProfileProvider.isLoading &&
          userProfileProvider.userData != null) {
        if (userProfileProvider.userData!.containsKey('animals')) {
          setState(() {
            _userPets = List<Map<String, dynamic>>.from(
                userProfileProvider.userData!['animals']);
          });
          return;
        }
      }

      // Fallback to loading directly from file
      final String response =
          await rootBundle.loadString('assets/data/usr01.json');
      final data = json.decode(response);

      setState(() {
        _userPets = List<Map<String, dynamic>>.from(data['animals']);
      });
    } catch (e) {
      print('Error loading user pets: $e');
    }
  }

  void _selectPet(Map<String, dynamic> pet) {
    setState(() {
      if (_selectedPet == pet) {
        // Deselect if the same pet is clicked again
        _selectedPet = null;
        _isManualEntryExpanded = true;
      } else {
        _selectedPet = pet;
        _isManualEntryExpanded = false;

        // Fill in form data from the selected pet
        formData['type'] = pet['type'];
        selectedType = pet['type'];

        if (pet['type'].toString().toLowerCase() == 'dog') {
          formData['breedSize'] = pet['size'];
          selectedBreedSize = pet['size'];
        }

        formData['gender'] = pet['sex'];
        formData['name'] = pet['name'];
        formData['breed'] = pet['breed'];
        formData['age'] = pet['age'].toString();

        // Additional pet information if available
        if (pet.containsKey('neuter')) {
          formData['neuter'] = pet['neuter'];
        }
      }
    });
  }

  List<Widget> _buildSection(int section) {
    switch (section) {
      case 0:
        return [
          // Pet selection section
          if (_userPets.isNotEmpty) ...[
            Card(
              margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
              elevation: 2,
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  'Select one of your pets',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: Column(
                      children: _userPets.map((pet) {
                        final bool isSelected = _selectedPet == pet;
                        return Stack(
                          children: [
                            CollapsibleAnimalItem(animal: pet),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.transparent,
                                ),
                                child: Checkbox(
                                  value: isSelected,
                                  onChanged: (_) => _selectPet(pet),
                                  shape: CircleBorder(),
                                  activeColor: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
          ],

          // Manual pet entry form (collapsible)
          Card(
            margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            elevation: 2,
            child: ExpansionTile(
              initiallyExpanded: _isManualEntryExpanded,
              title: Text(
                'Enter new pet information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onExpansionChanged: (expanded) {
                setState(() {
                  _isManualEntryExpanded = expanded;
                  if (expanded) {
                    _selectedPet = null;
                  }
                });
              },
              children: [
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ];

      case 1:
        // ...existing code...
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
        // ...existing code...
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
        // Summary view
        return [
          // Pet information section
          Card(
            margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pet Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Show selected pet card or manual entry data
                  if (_selectedPet != null)
                    CollapsibleAnimalItem(animal: _selectedPet!)
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Type: ${formData['type'] ?? 'Not specified'}'),
                        if (formData['type'] == 'Other')
                          Text('Specific type: ${formData['otherType'] ?? ''}'),
                        if (formData['type'] == 'Dog')
                          Text('Breed size: ${formData['breedSize'] ?? ''}'),
                        Text(
                            'Gender: ${formData['gender'] ?? 'Not specified'}'),
                        // Display animal questions answers
                        if (formJson != null &&
                            formJson!.containsKey('animalQuestions'))
                          ...formJson!['animalQuestions'].map((question) => Text(
                              '$question: ${formData[question] ?? 'Not answered'}')),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // Show rest of the summary sections (hotel questions, payment, etc.)
          Card(
            margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hotel Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  if (formJson != null &&
                      formJson!.containsKey('hotelQuestions'))
                    ...formJson!['hotelQuestions'].map((question) => Text(
                        '$question: ${formData[question] ?? 'Not answered'}')),
                ],
              ),
            ),
          ),

          // Payment section
          Card(
            margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment & Extras',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                      'Payment Method: ${formData['paymentMethod'] ?? 'Not selected'}'),
                  SizedBox(height: AppSpacing.sm),

                  // Show selected extras
                  if (formJson != null &&
                      formJson!.containsKey('extra_options')) ...[
                    Text('Selected Extras:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...formJson!['extra_options'].map((option) {
                      final bool isSelected = formData[option['name']] == true;
                      if (!isSelected) return SizedBox.shrink();

                      return Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('✓ ${option['name']} (\$${option['price']})'),
                            if (option['question'] != null &&
                                formData['${option['name']}_response'] != null)
                              Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  '${option['question']}: ${formData['${option['name']}_response']}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        ];

      default:
        return [];
    }
  }

  bool _isCurrentSectionValid() {
    // ...existing code...
    final currentFormState = _formKey.currentState;
    if (currentFormState != null) {
      return currentFormState.validate();
    }
    return false;
  }

  bool _isSection0Valid() {
    // If a pet is selected, this section is valid
    if (_selectedPet != null) return true;

    // Otherwise, check the manual entry form
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

  // ...existing code...
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
    // ...existing code...
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
                    SizedBox(height: AppSpacing.md),
                    if (_currentSection < 3)
                      ElevatedButton(
                        onPressed: () {
                          if (_currentSection == 0 && !_isSection0Valid()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Please either select a pet or fill in all required fields.'),
                              ),
                            );
                          } else if (_currentSection == 1 &&
                              !_isSection1Valid()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Please complete all fields in this section.'),
                              ),
                            );
                          } else {
                            _nextSection();
                          }
                        },
                        child: Text('Next'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (_currentSection == 3)
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit Reservation'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
