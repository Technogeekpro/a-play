import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';

part 'event_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EventModel {
  final String id;
  final String title;
  final String description;
  final int capacity;
  final num price;
  @JsonKey(name: 'category_id')
  final String categoryId;
  @JsonKey(name: 'start_date', fromJson: _parseDateTimeField)
  final DateTime startDate;
  @JsonKey(name: 'end_date', fromJson: _parseDateTimeField)
  final DateTime endDate;
  @JsonKey(name: 'location_name')
  final String locationName;
  final String address;
  final double? latitude;
  final double? longitude;
  @JsonKey(name: 'organizer_id')
  final String organizerId;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'is_featured')
  final bool isFeatured;
  final String status;
  @JsonKey(name: 'created_at', fromJson: _parseDateTimeField)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', fromJson: _parseDateTimeField)
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.capacity,
    required this.price,
    required this.categoryId,
    required this.startDate,
    required this.endDate,
    required this.locationName,
    required this.address,
    this.latitude,
    this.longitude,
    required this.organizerId,
    this.imageUrl,
    required this.isFeatured,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  static DateTime _parseDateTimeField(dynamic value) {
    try {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      return DateTime.parse(value.toString());
    } catch (e) {
      debugPrint('Error parsing date: $e for value: $value');
      return DateTime.now();
    }
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint('Creating EventModel from JSON: $json');
      
      // Provide default values for required fields
      json['id'] ??= '';
      json['title'] ??= '';
      json['description'] ??= '';
      json['capacity'] ??= 0;
      json['price'] ??= 0;
      json['category_id'] ??= '';
      json['location_name'] ??= '';
      json['address'] ??= '';
      json['organizer_id'] ??= '';
      json['is_featured'] ??= false;
      json['status'] ??= 'pending';

      // Handle numeric fields that might be strings
      if (json['capacity'] is String) {
        json['capacity'] = int.tryParse(json['capacity'] as String) ?? 0;
      }
      if (json['price'] is String) {
        json['price'] = double.tryParse(json['price'] as String) ?? 0.0;
      }
      if (json['latitude'] is String) {
        json['latitude'] = double.tryParse(json['latitude'] as String);
      }
      if (json['longitude'] is String) {
        json['longitude'] = double.tryParse(json['longitude'] as String);
      }

      final model = _$EventModelFromJson(json);
      debugPrint('Successfully created EventModel with ID: ${model.id}');
      return model;
    } catch (e, stackTrace) {
      debugPrint('Error creating EventModel: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  // Helper getters
  bool get isActive => status == 'active';
  String get location => locationName;
  String get displayLocation => locationName.split(',').first;
  
  String get formattedStartDate {
    return '${startDate.day}/${startDate.month}/${startDate.year} at ${startDate.hour}:${startDate.minute.toString().padLeft(2, '0')}';
  }
  
  String get formatedPrice {
    return 'GHS ${price.toStringAsFixed(2)}';
  }

  String get displayPrice {
    return 'GHS ${price.toStringAsFixed(2)}';
  }

  String get formattedDate { 
    return DateFormat('EEE, d MMM').format(startDate);
  }

  String get formattedTime {
    return DateFormat('h:mm a').format(startDate);
  }
} 