import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ReservationService {
  static Future<Map<String, dynamic>> loadReservation(
      String reservationId) async {
    try {
      final Map<String, String> knownReservations = {
        'E5F6G7H8': 'assets/data/E5F6G7H8.json',
        'I9J1K2L3': 'assets/data/I9J1K2L3.json',
        'Q8R9S1T2': 'assets/data/Q8R9S1T2.json',
      };

      if (knownReservations.containsKey(reservationId)) {
        final String filePath = knownReservations[reservationId]!;
        
        try {
          final String response = await rootBundle.loadString(filePath);
          final data = json.decode(response);
          return data;
        } catch (e) {
          // Continue to default file
        }
      }

      final String defaultPath = 'assets/data/reservation_details.json';
      final String response = await rootBundle.loadString(defaultPath);
      final data = json.decode(response);
      return data;
    } catch (e) {
      throw "Could not load reservation details. Please try again later.";
    }
  }

  static bool isRecentlyCompleted(Map<String, dynamic> reservation) {
    if (reservation.isEmpty ||
        !reservation.containsKey('date') ||
        !reservation.containsKey('status')) {
      return false;
    }

    final status = reservation['status'].toString().toLowerCase();
    if (status != "completed" && status != "finished") {
      return false;
    }

    try {
      DateTime reservationDate;
      try {
        reservationDate = DateFormat("MM/dd/yyyy").parse(reservation['date']);
      } catch (e) {
        try {
          reservationDate = DateFormat("yyyy-MM-dd").parse(reservation['date']);
        } catch (e) {
          reservationDate = DateFormat("dd/MM/yyyy").parse(reservation['date']);
        }
      }

      final now = DateTime.now();
      final difference = now.difference(reservationDate).inDays;

      return difference >= 0 && difference <= 7;
    } catch (e) {
      return false;
    }
  }
}
