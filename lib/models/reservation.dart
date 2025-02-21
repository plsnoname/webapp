import 'package:fatcherappv2/models/animal.dart';
import 'package:fatcherappv2/models/person.dart';
import 'package:fatcherappv2/models/room.dart';

class Reservation {
  final Person person;
  final List<Animal> animals;
  final List<Extra> extras;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String additionalDetails;
  final String paymentMethod;
  final String contact;
  final String reservationCode;
  final String? paymentIssueDetails;
  final Room room;
  final String arrivalTime;

  Reservation({
    required this.person,
    required this.animals,
    required this.extras,
    required this.checkInDate,
    required this.checkOutDate,
    required this.additionalDetails,
    required this.paymentMethod,
    required this.contact,
    required this.reservationCode,
    this.paymentIssueDetails,
    required this.room,
    required this.arrivalTime,
  });
}
