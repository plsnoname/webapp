import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../shared/widgets/calendar_date_picker.dart';
import '../services/hotel_availability_service.dart';

class HotelDetailScreen extends StatefulWidget {
  final String hotelId;
  final String hotelName;
  
  const HotelDetailScreen({
    Key? key, 
    required this.hotelId, 
    required this.hotelName
  }) : super(key: key);

  @override
  _HotelDetailScreenState createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  DateTimeRange? _selectedDateRange;
  bool _isLoading = false;

  Future<void> _selectDates() async {
    setState(() {
      _isLoading = true;
    });
    
    // Get this specific hotel's unavailable dates
    final List<DateTime> unavailableDates = 
        await HotelAvailabilityService.getOccupiedDates(widget.hotelId);
    
    setState(() {
      _isLoading = false;
    });
    
    final result = await showHotelDatePicker(
      context: context,
      hotelId: widget.hotelId,
      unavailableDates: unavailableDates,
      initialDateRange: _selectedDateRange,
    );
    
    if (result != null) {
      setState(() {
        _selectedDateRange = result;
      });
      
      // Here you might update room availability or pricing
      print('Selected dates for ${widget.hotelName}: ${result.start} to ${result.end}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hotelName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel image
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: Center(
                child: Icon(Icons.hotel, size: 80, color: Colors.grey.shade600),
              ),
            ),
            
            // Hotel details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hotelName,
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ID: ${widget.hotelId}',
                    style: TextStyle(
                      color: Colors.grey.shade600
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Date selection section
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Your Stay Dates',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          
                          // Date display
                          if (_selectedDateRange != null)
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Check-in',
                                        style: TextStyle(color: Colors.grey.shade600)),
                                      Text(
                                        DateFormat('EEE, MMM d, yyyy').format(_selectedDateRange!.start),
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward, color: Colors.grey),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Check-out',
                                        style: TextStyle(color: Colors.grey.shade600)),
                                      Text(
                                        DateFormat('EEE, MMM d, yyyy').format(_selectedDateRange!.end),
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          
                          SizedBox(height: 16),
                          
                          // Date picker button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _selectDates,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(strokeWidth: 2)
                                  : Text(
                                      _selectedDateRange == null
                                          ? 'Select Dates'
                                          : 'Change Dates',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Booking section
                  if (_selectedDateRange != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Duration:'),
                              Text(
                                '${_selectedDateRange!.duration.inDays} nights',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total:'),
                              Text(
                                '\$${_selectedDateRange!.duration.inDays * 100}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Proceed to booking
                                print('Booking ${widget.hotelName} from ${_selectedDateRange!.start} to ${_selectedDateRange!.end}');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text(
                                'Book Now',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
