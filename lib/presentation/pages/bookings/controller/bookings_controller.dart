import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a_play/data/models/booking/booking_model.dart';
import 'package:a_play/core/config/supabase_config.dart';
import 'package:flutter/foundation.dart';

class BookingException implements Exception {
  final String message;
  final String? field;
  final dynamic value;
  final String? stackTrace;

  BookingException(this.message, {this.field, this.value, this.stackTrace});

  @override
  String toString() {
    var error = 'BookingException: $message';
    if (field != null) error += '\nField: $field';
    if (value != null) error += '\nValue: $value';
    if (stackTrace != null) error += '\nStack Trace: $stackTrace';
    return error;
  }
}

final bookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  try {
    final currentUser = SupabaseConfig.client.auth.currentUser;
    if (currentUser == null) {
      throw BookingException('User not authenticated');
    }

    debugPrint('Fetching bookings for user: ${currentUser.id}');

    final response = await SupabaseConfig.client
        .from('bookings')
        .select('''
          *,
          event:events (
            id,
            title,
            description,
            location_name,
            image_url,
            start_date,
            end_date,
            price,
            status
          )
        ''')
        .eq('user_id', currentUser.id)
        .order('created_at', ascending: false);

    debugPrint('Raw bookings response: $response');

    List<BookingModel> bookings = [];
    for (var json in response) {
      try {
        debugPrint('Processing booking JSON: $json');
        
        // Validate numeric fields before parsing
        if (json['quantity'] == null) {
          debugPrint('Quantity is null for booking ${json['id']}, setting to 0');
          json['quantity'] = 0;
        }
        
        if (json['total_amount'] == null) {
          debugPrint('Total amount is null for booking ${json['id']}, setting to 0.0');
          json['total_amount'] = 0.0;
        }

        // Convert numeric fields to the correct type
        if (json['quantity'] is String) {
          json['quantity'] = int.parse(json['quantity'] as String);
        }
        
        if (json['total_amount'] is String) {
          json['total_amount'] = double.parse(json['total_amount'] as String);
        }

        // Validate event data
        if (json['event'] == null) {
          debugPrint('Warning: Event data is null for booking ${json['id']}');
        } else {
          debugPrint('Event data for booking ${json['id']}: ${json['event']}');
        }

        // Create booking model
        final booking = BookingModel.fromJson(json);
        debugPrint('Successfully created booking model for ID: ${booking.id}');
        bookings.add(booking);
      } catch (e, stackTrace) {
        debugPrint('Error processing booking: $e');
        debugPrint('Stack trace: $stackTrace');
        debugPrint('Problematic JSON: $json');
        
        throw BookingException(
          'Failed to parse booking',
          field: json['id']?.toString() ?? 'unknown',
          value: json.toString(),
          stackTrace: stackTrace.toString(),
        );
      }
    }

    debugPrint('Successfully processed ${bookings.length} bookings');
    return bookings;
  } catch (e, stackTrace) {
    debugPrint('Error in bookingsProvider: $e');
    debugPrint('Stack trace: $stackTrace');
    
    if (e is BookingException) {
      rethrow;
    }
    throw BookingException(
      'Failed to fetch bookings',
      value: e.toString(),
      stackTrace: stackTrace.toString(),
    );
  }
}); 