import 'package:flutter/material.dart';
import 'package:a_play_world/data/models/event/event_model.dart';
import 'package:a_play_world/presentation/widgets/home/event_list_item.dart';

class AllEventsSection extends StatelessWidget {
  final List<EventModel> events;

  const AllEventsSection({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: EventListItem(event: events[index]),
            );
          },
          childCount: events.length,
        ),
      ),
    );
  }
}
