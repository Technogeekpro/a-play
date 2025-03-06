import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:a_play_world/core/theme/app_text_styles.dart';
import 'package:a_play_world/core/theme/app_colors.dart';
import 'package:iconsax/iconsax.dart';

/// Search bar widget for the home page
class SearchBarSection extends StatelessWidget {
  const SearchBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121212),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GestureDetector(
          onTap: () => context.push('/search'),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.cardBackgroundDark,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.search,
                  color: Colors.grey[500],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Search events',
                  style: AppTextStyles.bodyMedium(color: Colors.grey[500]),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Iconsax.filter_tick,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
