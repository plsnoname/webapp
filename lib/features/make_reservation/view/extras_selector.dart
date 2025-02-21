import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import '../components/general_dropdown_field.dart';
import '../components/checkbox_list_item.dart';

class ExtrasSelector extends StatefulWidget {
  const ExtrasSelector({Key? key}) : super(key: key);

  @override
  _ExtrasSelectorState createState() => _ExtrasSelectorState();
}

class _ExtrasSelectorState extends State<ExtrasSelector> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, bool> _selectedOptions = {};
  final Map<String, String?> _answers = {};
  String? _selectedPaymentMethod;
  List<Map<String, dynamic>> _options = [];
  List<String> _paymentMethods = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String jsonString =
        await rootBundle.loadString('assets/data/extra_options.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    setState(() {
      _options = List<Map<String, dynamic>>.from(jsonData['extra_options']);
      _paymentMethods = List<String>.from(jsonData['accepted_payment_methods']);
      for (var option in _options) {
        _selectedOptions[option['name']] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Extras Selector'),
          centerTitle: true,
        ),
        body: _options.isEmpty || _paymentMethods.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GeneralDropdownField<String>(
                        labelText: 'Accepted Payment Methods',
                        items: _paymentMethods,
                        value: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                      ),
                      ..._options.map((option) {
                        return CheckboxListItem(
                          title: option['name'],
                          price: option['price'],
                          value: _selectedOptions[option['name']]!,
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedOptions[option['name']] = value ?? false;
                            });
                          },
                          question: option['question'],
                        );
                      }).toList(),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              bool allQuestionsAnswered = true;
                              _selectedOptions.forEach((key, value) {
                                if (value && _answers[key] == null) {
                                  allQuestionsAnswered = false;
                                }
                              });
                              if (allQuestionsAnswered) {
                                context.go(
                                  '/home/hotelDetails/animalForm/animalFormStageTwo/extrasSelector/summary',
                                  extra: {
                                    'Payment Method': _selectedPaymentMethod,
                                    'Selected Options': _selectedOptions,
                                    'Answers': _answers,
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please answer all required questions.'),
                                  ),
                                );
                              }
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
                            'Go to Reservation Summary',
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
