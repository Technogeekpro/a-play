import 'package:a_play/data/models/event/event_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pushNamed(
          'event-detail',
          pathParameters: {'id': event.id},
          extra: event,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
                aspectRatio: 4 / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Hero(
                      tag: 'event-image-${event.id}',
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: event.imageUrl ?? '',
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.grey[300],
                          ),
                        ),
                      )),
                )),
            const SizedBox(height: 8),
            Hero(
              tag: 'event-title-${event.id}',
              child: Text(
                event.title,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.fade,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Iconsax.location5,
                  size: 14,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 4),
                Text(event.location,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                        )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
