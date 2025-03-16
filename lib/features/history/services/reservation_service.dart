import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ReservationService {
  static Future<Map<String, dynamic>> loadReservation(
      String reservationId) async {
    try {
      print("Attempting to load data for reservation ID: $reservationId");

      // List of known reservation IDs with their exact filename
      final Map<String, String> knownReservations = {
        'E5F6G7H8': 'assets/data/E5F6G7H8.json',
        'I9J1K2L3': 'assets/data/I9J1K2L3.json',
        'Q8R9S1T2': 'assets/data/Q8R9S1T2.json',
      };

      // First try loading specific file if it's a known ID
      if (knownReservations.containsKey(reservationId)) {
        final String filePath = knownReservations[reservationId]!;
        print("Reservation ID matched with known file: $filePath");

        try {
          final String response = await rootBundle.loadString(filePath);
          print("Successfully loaded file content");

          final data = json.decode(response);
          print("Successfully parsed JSON");

          return data;
        } catch (e) {
          print("Failed to load specific reservation file: $e");
          // Continue to default file
        }
      }

      // If we reach here, either the ID wasn't known or the file couldn't be loaded
      print("Loading default reservation file");
      final String defaultPath = 'assets/data/reservation_details.json';

      final String response = await rootBundle.loadString(defaultPath);
      final data = json.decode(response);
      return data;
    } catch (e) {
      print("Unhandled error in loadReservationData: $e");
      throw "Could not load reservation details. Please try again later.";
    }
  }

  static bool isRecentlyCompleted(Map<String, dynamic> reservation) {
    if (reservation.isEmpty ||
        !reservation.containsKey('date') ||
        !reservation.containsKey('status')) {
      return false;
    }

    // Check if status is 'completed' or similar - using lowercase consistently
    final status = reservation['status'].toString().toLowerCase();
    if (status != "completed" && status != "finished") {
      print("Reservation status: $status - not showing review button");
      return false;
    }

    try {
      // Parse the reservation date - try multiple formats
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

      // Debug info
      print("Reservation date: $reservationDate, days since: $difference");

      // Check if completed within last 7 days
      return difference >= 0 && difference <= 7;
    } catch (e) {
      print("Error parsing reservation date: ${reservation['date']} - $e");
      return false;
    }
  }
}
