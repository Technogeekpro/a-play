import 'package:a_play_world/data/models/event/event_model.dart';
import 'package:a_play_world/data/models/user/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReviewModel {
  final String id;
  @JsonKey(name: 'event_id')
  final String eventId;
  @JsonKey(name: 'user_id')
  final String userId;
  final int rating;
  final String comment;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  // Relationships
  final UserModel? user;
  final EventModel? event;

  ReviewModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.event,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
} 