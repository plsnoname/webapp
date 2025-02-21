import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../components/general_text_field.dart';

class AnimalFormStageTwo extends StatefulWidget {
  const AnimalFormStageTwo({Key? key}) : super(key: key);

  @override
  _AnimalFormStageTwoState createState() => _AnimalFormStageTwoState();
}

class _AnimalFormStageTwoState extends State<AnimalFormStageTwo> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String?> _answers = {};
  List<Map<String, dynamic>> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/questions.json');
      final Map<String, dynamic> data = json.decode(response);
      setState(() {
        _questions = List<Map<String, dynamic>>.from(data['questions']);
      });
    } catch (e) {
      print('Error loading questions: $e');
    }
  }

  Future<void> _saveToStorage() async {
    final storage = FlutterSecureStorage();
    for (var entry in _answers.entries) {
      await storage.write(key: entry.key, value: entry.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Additional Information'),
        centerTitle: true,
      ),
      body: _questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._questions.map((question) {
                      return GeneralTextField(
                        labelText: question['question'] ?? '',
                        onSaved: (value) {
                          _answers[question['id'] ?? ''] = value;
                        },
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please answer this question'
                            : null,
                      );
                    }).toList(),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await _saveToStorage();
                            _answers.forEach((key, value) {
                              print('Question $key: $value');
                            });
                            GoRouter.of(context).go(
                                '/home/hotelDetails/animalForm/animalFormStageTwo/extrasSelector');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(),
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Submit',
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
