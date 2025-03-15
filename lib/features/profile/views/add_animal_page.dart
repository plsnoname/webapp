import 'package:flutter/material.dart';
import 'package:fatcherappv2/design_system/typography.dart';
import 'package:fatcherappv2/design_system/spacing.dart';
import 'package:fatcherappv2/shared/widgets/unified_text_field.dart';
import 'package:fatcherappv2/features/make_reservation/components/general_dropdown_field.dart';
import 'package:fatcherappv2/shared/utils/form_validators.dart';

class AddAnimalPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddAnimal;

  const AddAnimalPage({Key? key, required this.onAddAnimal}) : super(key: key);

  @override
  _AddAnimalPageState createState() => _AddAnimalPageState();
}

class _AddAnimalPageState extends State<AddAnimalPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _animalData = {
    'type': '',
    'name': '',
    'breed': '',
    'sex': '',
    'age': '',
    'size': '',
    'neuter': '',
  };

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onAddAnimal(_animalData);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Animal', style: AppTypography.heading3),
      ),
      body: Padding(
        padding: AppSpacing.paddingMD,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              UnifiedTextField(
                labelText: 'Type',
                style: TextFieldStyle.general,
                onSaved: (value) {
                  _animalData['type'] = value!;
                },
                validator: FormValidators.required,
              ),
              AppSpacing.verticalSpaceMD,
              UnifiedTextField(
                labelText: 'Name',
                style: TextFieldStyle.general,
                onSaved: (value) {
                  _animalData['name'] = value!;
                },
                validator: FormValidators.required,
              ),
              AppSpacing.verticalSpaceMD,
              UnifiedTextField(
                labelText: 'Breed',
                style: TextFieldStyle.general,
                onSaved: (value) {
                  _animalData['breed'] = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a breed';
                  }
                  return null;
                },
              ),
              AppSpacing.verticalSpaceMD,
              GeneralDropdownField<String>(
                labelText: 'Sex',
                items: ['Male', 'Female'],
                onChanged: (value) {
                  _animalData['sex'] = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a sex';
                  }
                  return null;
                },
              ),
              AppSpacing.verticalSpaceMD,
              UnifiedTextField(
                labelText: 'Age',
                style: TextFieldStyle.general,
                onSaved: (value) {
                  _animalData['age'] = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  return null;
                },
              ),
              AppSpacing.verticalSpaceMD,
              GeneralDropdownField<String>(
                labelText: 'Size',
                items: ['Small', 'Medium', 'Large'],
                onChanged: (value) {
                  _animalData['size'] = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a size';
                  }
                  return null;
                },
              ),
              AppSpacing.verticalSpaceMD,
              GeneralDropdownField<String>(
                labelText: 'Neuter',
                items: ['Yes', 'No'],
                onChanged: (value) {
                  _animalData['neuter'] = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select neuter status';
                  }
                  return null;
                },
              ),
              AppSpacing.verticalSpaceLG,
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Save', style: AppTypography.buttonLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
