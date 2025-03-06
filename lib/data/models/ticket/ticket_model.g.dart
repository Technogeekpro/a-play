// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketModel _$TicketModelFromJson(Map<String, dynamic> json) => TicketModel(
      id: json['id'] as String,
      price: json['price'] as num,
      eventId: json['event_id'] as String,
      ticketType: json['ticket_type'] as String,
      availableQuantity: (json['quantity_available'] as num).toInt(),
      soldQuantity: (json['quantity_sold'] as num).toInt(),
      saleEndsAt: DateTime.parse(json['sale_ends_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TicketModelToJson(TicketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'event_id': instance.eventId,
      'ticket_type': instance.ticketType,
      'quantity_available': instance.availableQuantity,
      'quantity_sold': instance.soldQuantity,
      'sale_ends_at': instance.saleEndsAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
