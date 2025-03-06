// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      capacity: (json['capacity'] as num).toInt(),
      price: json['price'] as num,
      categoryId: json['category_id'] as String,
      startDate: EventModel._parseDateTimeField(json['start_date']),
      endDate: EventModel._parseDateTimeField(json['end_date']),
      locationName: json['location_name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      organizerId: json['organizer_id'] as String,
      imageUrl: json['image_url'] as String?,
      isFeatured: json['is_featured'] as bool,
      status: json['status'] as String,
      createdAt: EventModel._parseDateTimeField(json['created_at']),
      updatedAt: EventModel._parseDateTimeField(json['updated_at']),
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'capacity': instance.capacity,
      'price': instance.price,
      'category_id': instance.categoryId,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'location_name': instance.locationName,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'organizer_id': instance.organizerId,
      'image_url': instance.imageUrl,
      'is_featured': instance.isFeatured,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
