import 'dart:convert';
import 'package:flutter/services.dart';

class HotelAvailabilityService {
  static final Map<String, List<DateTime>> _cachedOccupiedDates = {};
  
  static Future<List<DateTime>> getOccupiedDates(String hotelId) async {
    // Return from cache if available
    if (_cachedOccupiedDates.containsKey(hotelId)) {
      return _cachedOccupiedDates[hotelId]!;
    }
    
    try {
      // Load the JSON file
      final String jsonData = await rootBundle.loadString('assets/data/occupied_dates.json');
      final data = json.decode(jsonData);
      
      // Find the hotel in the JSON data
      final hotels = data['hotels'] as List;
      final hotelData = hotels.firstWhere(
        (hotel) => hotel['id'] == hotelId,
        orElse: () => {'occupied_dates': []},
      );
      
      // Parse the occupied dates
      final occupiedDatesStrings = hotelData['occupied_dates'] as List;
      final occupiedDates = occupiedDatesStrings
          .map((dateStr) => DateTime.parse(dateStr))
          .toList();
      
      // Store in cache
      _cachedOccupiedDates[hotelId] = occupiedDates;
      
      return occupiedDates;
    } catch (e) {
      return [];
    }
  }
}
