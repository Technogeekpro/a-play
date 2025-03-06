import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_play_world/data/models/event/event_model.dart';
import 'package:a_play_world/data/models/ticket/ticket_model.dart';
import 'package:a_play_world/core/config/supabase_config.dart';

/// Provider for categories
final categoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    // Try to get cached categories first
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('categories');
    
    if (cachedData != null) {
      final List<dynamic> decoded = json.decode(cachedData);
      return List<Map<String, dynamic>>.from(decoded);
    }

    // If no cache, fetch from Supabase
    final response = await SupabaseConfig.client
        .from('categories')
        .select()
        .order('name');

    // Cache the response
    await prefs.setString('categories', json.encode(response));
    
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    throw Exception('Failed to fetch categories: $e');
  }
});

/// Provider for events with offline support
final eventsProvider = FutureProvider<List<EventModel>>((ref) async {
  try {
    // Try to get cached events first
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('events');
    final lastFetch = prefs.getInt('events_last_fetch') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Use cache if it's less than 5 minutes old
    if (cachedData != null && (now - lastFetch < 5 * 60 * 1000)) {
      final List<dynamic> decoded = json.decode(cachedData);
      return decoded.map((json) => EventModel.fromJson(json)).toList();
    }

    // Fetch fresh data from Supabase
    final response = await SupabaseConfig.client
        .from('events')
        .select();

    // Cache the response and timestamp
    await prefs.setString('events', json.encode(response));
    await prefs.setInt('events_last_fetch', now);

    final eventsList = response as List;
    final List<EventModel> events = [];
    final defaultDate = DateTime.now().toIso8601String();

    // Process each event in the list
    for (var json in eventsList) {
      try {
        final safeJson = Map<String, dynamic>.from(json);
        _processDateFields(safeJson, defaultDate);
        _processBasicFields(safeJson);
        final event = EventModel.fromJson(safeJson);
        events.add(event);
      } catch (e) {
        continue;
      }
    }

    return events;
  } catch (e) {
    // If fetching fails, try to use cached data regardless of age
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('events');
      if (cachedData != null) {
        final List<dynamic> decoded = json.decode(cachedData);
        return decoded.map((json) => EventModel.fromJson(json)).toList();
      }
    } catch (_) {
      // If even cached data fails, rethrow original error
    }
    throw Exception('Failed to fetch events: $e');
  }
});

/// Provider for filtered events
final filteredEventsProvider = Provider.family<List<EventModel>, String?>((ref, categoryId) {
  final eventsAsync = ref.watch(eventsProvider);
  return eventsAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (events) {
      if (categoryId == null || categoryId == 'All') {
        return events;
      }
      return events.where((event) => event.categoryId == categoryId).toList();
    },
  );
});

/// Provider that fetches tickets for a specific event
final eventTicketsProvider = FutureProvider.family<List<TicketModel>, String>((ref, eventId) async {
  try {
    final response = await SupabaseConfig.client
        .from('tickets')
        .select()
        .eq('event_id', eventId)
        .order('price');

    print('response: $response');

    final ticketsList = response as List;
    final now = DateTime.now().toIso8601String();
    
    return ticketsList.map((json) {
      try {
        final safeJson = Map<String, dynamic>.from(json);
        
        // Process ticket date fields
        final dateFields = ['sale_ends_at', 'created_at', 'updated_at'];
        for (final field in dateFields) {
          safeJson[field] = safeJson[field] != null 
              ? DateTime.parse(safeJson[field]).toIso8601String()
              : now;
        }
        
        // Process basic ticket fields
        safeJson['id'] = safeJson['id']?.toString() ?? '';
        safeJson['price'] = num.tryParse(safeJson['price']?.toString() ?? '0') ?? 0;
        safeJson['event_id'] = safeJson['event_id']?.toString() ?? '';
        safeJson['ticket_type'] = safeJson['ticket_type']?.toString() ?? '';
        safeJson['quantity_available'] = int.tryParse(safeJson['quantity_available']?.toString() ?? '0') ?? 0;
        safeJson['quantity_sold'] = int.tryParse(safeJson['quantity_sold']?.toString() ?? '0') ?? 0;
        
        return TicketModel.fromJson(safeJson);
      } catch (_) {
        return null;
      }
    })
    .where((ticket) => ticket != null)
    .cast<TicketModel>()
    .toList();
  } catch (e) {
    throw Exception('Failed to fetch tickets for event: $eventId');
  }
});

/// Processes and validates date fields in the event JSON.
void _processDateFields(Map<String, dynamic> json, String defaultDate) {
  final dateFields = ['start_date', 'end_date', 'created_at', 'updated_at'];
  
  for (final field in dateFields) {
    try {
      json[field] = json[field] != null 
          ? DateTime.parse(json[field]).toIso8601String()
          : defaultDate;
    } catch (_) {
      json[field] = defaultDate;
    }
  }
}

/// Processes and validates basic fields in the event JSON.
void _processBasicFields(Map<String, dynamic> json) {
  json['id'] = json['id']?.toString() ?? '';
  json['title'] = json['title']?.toString() ?? '';
  json['description'] = json['description']?.toString() ?? '';
  json['capacity'] = int.tryParse(json['capacity']?.toString() ?? '0') ?? 0;
  json['price'] = num.tryParse(json['price']?.toString() ?? '0') ?? 0;
  json['category_id'] = json['category_id']?.toString() ?? '';
  json['location_name'] = json['location_name']?.toString() ?? '';
  json['address'] = json['address']?.toString() ?? '';
  json['latitude'] = double.tryParse(json['latitude']?.toString() ?? '0.0');
  json['longitude'] = double.tryParse(json['longitude']?.toString() ?? '0.0');
  json['organizer_id'] = json['organizer_id']?.toString() ?? '';
  json['image_url'] = json['image_url']?.toString();
  json['is_featured'] = json['is_featured'] ?? false;
  json['status'] = json['status']?.toString() ?? 'draft';
}

