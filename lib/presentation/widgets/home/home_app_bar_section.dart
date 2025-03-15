import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a_play_world/core/services/location_service.dart';

class HomeAppBarSection extends ConsumerWidget {
  const HomeAppBarSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(currentLocationProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App Logo in svg
          GestureDetector(
            onTap: () {
              // Navigate to profile page using go_router
              context.push('/profile');
            },
            child: SvgPicture.asset(
              'assets/images/app_logo.svg',
              height: 35,
            ),
          ),

          // Location display
          _buildLocationDisplay(context, ref),
        ],
      ),
    );
  }

  Widget _buildLocationDisplay(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(currentLocationProvider);
    
    return GestureDetector(
      onTap: () => context.push('/location'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: locationState.when(
          data: (location) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(PhosphorIconsLight.mapPin, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  location?.city ?? 'Set Location',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(PhosphorIconsLight.caretDown, color: Colors.white, size: 12),
              ],
            );
          },
          loading: () => const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
          error: (_, __) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(PhosphorIconsLight.mapPin, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                'Set Location',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(PhosphorIconsLight.caretDown, color: Colors.white, size: 12),
            ],
          ),
        ),
      ),
    );
  }
}
