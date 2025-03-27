import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../shared/widgets/calendar_date_picker.dart';
import '../services/hotel_availability_service.dart';

class HotelListScreen extends StatefulWidget {
  const HotelListScreen({Key? key}) : super(key: key);

  @override
  _HotelListScreenState createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  DateTimeRange? _selectedDateRange;
  
  Future<void> _selectDates(BuildContext context) async {
    // Get unavailable dates from service
    final List<DateTime> unavailableDates = await HotelAvailabilityService.getOccupiedDates('hotel_1');
    
    final result = await showHotelDatePicker(
      context: context,
      hotelId: 'hotel_list',
      unavailableDates: unavailableDates,
      initialDateRange: _selectedDateRange,
    );
    
    if (result != null) {
      setState(() {
        _selectedDateRange = result;
      });
      // Use the selected dates for filtering
      print('Selected: ${result.start} - ${result.end}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels'),
        actions: [
          // Date selector button in app bar
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDates(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date range display/selector
          if (_selectedDateRange != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () => _selectDates(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.date_range, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        '${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.edit, size: 16, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ),

          // List of hotels would go here
          Expanded(
            child: ListView(
              children: [
                // Your hotel list items would go here
                _buildHotelListItem('hotel_1', 'Grand Plaza Hotel'),
                _buildHotelListItem('hotel_2', 'Ocean View Resort'),
                _buildHotelListItem('hotel_3', 'Mountain Lodge'),
              ],
            ),
          ),
        ],
      ),
      // Floating action button to open date picker
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectDates(context),
        child: Icon(Icons.calendar_today),
        tooltip: 'Select Dates',
      ),
    );
  }

  Widget _buildHotelListItem(String hotelId, String hotelName) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(hotelName),
        subtitle: Text('Tap to view details'),
        trailing: ElevatedButton(
          onPressed: () => Navigator.pushNamed(
            context, 
            '/hotel-detail',
            arguments: {'id': hotelId, 'name': hotelName},
          ),
          child: Text('View'),
        ),
      ),
    );
  }
}
