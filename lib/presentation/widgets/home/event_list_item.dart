import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:a_play_world/data/models/event/event_model.dart';
import 'package:a_play_world/core/theme/app_text_styles.dart';

class EventListItem extends StatelessWidget {
  final EventModel event;

  const EventListItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        'event-detail',
        pathParameters: {'id': event.id},
        extra: event,
      ),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Day and Month
          _buildDateDisplay(),
          
          const SizedBox(width: 12),
          
          // Right side - Event details
          _buildEventDetails(),
        ],
      ),
    );
  }

  Widget _buildDateDisplay() {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('EEE').format(event.startDate).toUpperCase(),
            style: AppTextStyles.caption(color: Colors.grey[400]),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('dd').format(event.startDate),
            style: AppTextStyles.headingSmall(),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('MMM').format(event.startDate),
            style: AppTextStyles.caption(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: AppTextStyles.labelLarge(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            event.locationName,
            style: AppTextStyles.bodySmall(color: Colors.grey[400]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${event.capacity} attendees',
            style: AppTextStyles.caption(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
