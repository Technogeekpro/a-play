import 'package:json_annotation/json_annotation.dart';
import 'package:a_play_world/data/models/event/event_model.dart';

part 'booking_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BookingModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'event_id')
  final String eventId;
  @JsonKey(name: 'ticket_id')
  final String ticketId;
  @JsonKey(fromJson: _parseQuantity)
  final int quantity;
  @JsonKey(name: 'total_amount', fromJson: _parseTotalAmount)
  final double totalAmount;
  final String status;
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'customer_name')
  final String customerName;
  @JsonKey(name: 'customer_email')
  final String customerEmail;
  @JsonKey(name: 'customer_phone')
  final String customerPhone;
  @JsonKey(name: 'tickets')
  final List<Map<String, dynamic>> tickets;

  // Relationships
  @JsonKey(name: 'event')
  final EventModel? event;

  BookingModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.ticketId,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    this.event,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.tickets,
  });

  // Custom parsers for numeric fields
  static int _parseQuantity(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.parse(value);
    return 0;
  }

  static double _parseTotalAmount(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    try {
      // Ensure required fields exist
      json['id'] ??= '';
      json['user_id'] ??= '';
      json['event_id'] ??= '';
      json['ticket_id'] ??= '';
      json['status'] ??= 'pending';
      json['payment_status'] ??= 'pending';
      json['customer_name'] ??= '';
      json['customer_email'] ??= '';
      json['customer_phone'] ??= '';
      json['tickets'] ??= <Map<String, dynamic>>[];

      // Handle dates
      json['created_at'] ??= DateTime.now().toIso8601String();
      json['updated_at'] ??= DateTime.now().toIso8601String();

      return _$BookingModelFromJson(json);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  // Helper getters
  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isPaid => paymentStatus == 'paid';
  bool get isPaymentPending => paymentStatus == 'pending';
  bool get isPaymentFailed => paymentStatus == 'failed';
} 