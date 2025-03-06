import 'package:json_annotation/json_annotation.dart';


part 'ticket_model.g.dart';

@JsonSerializable()
class TicketModel {
  final String id;
  final num price;
  @JsonKey(name: 'event_id')
  final String eventId;
  @JsonKey(name: 'ticket_type')
  final String ticketType;
  @JsonKey(name: 'quantity_available')
  final int availableQuantity;
  @JsonKey(name: 'quantity_sold')
  final int soldQuantity;
  @JsonKey(name:'sale_ends_at')
  final DateTime saleEndsAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const TicketModel({
    required this.id,
    required this.price,
    required this.eventId,
    required this.ticketType,
    required this.availableQuantity,
    required this.soldQuantity,
    required this.saleEndsAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    // Ensure all required fields have non-null values
    json['id'] ??= '';
    json['name'] ??= '';
    json['price'] ??= 0;
    json['event_id'] ??= '';
    json['ticket_type'] ??= '';
    json['quantity_available'] ??= 0;
    
    // Handle date fields
    final now = DateTime.now().toIso8601String();
    json['sale_ends_at'] ??= now;
    json['created_at'] ??= now;
    json['updated_at'] ??= now;

    return _$TicketModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TicketModelToJson(this);

  String get formattedPrice => 'GH₵${price.toStringAsFixed(2)}';
  bool get isAvailable => availableQuantity > 0;
  String get formattedSaleEndsAt => '${saleEndsAt.day}/${saleEndsAt.month}/${saleEndsAt.year}';
} 