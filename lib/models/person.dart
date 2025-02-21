import 'package:fatcherappv2/models/animal.dart';

class Person {
  final String name;
  final String phoneNumber;
  final String email;
  final List<String> reviews;
  final List<Animal>? animals;

  Person({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.reviews,
    this.animals,
  });
}
