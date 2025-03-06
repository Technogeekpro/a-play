import 'package:flutter/material.dart';
import 'package:a_play_world/presentation/theme/app_theme.dart';

class CategoryPill extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryPill({
    super.key,
    required this.title,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryPurple 
              : AppTheme.surfaceMedium,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryPurple 
                : AppTheme.surfaceLight.withOpacity(0.6),
            width: 1,
          ),
          boxShadow: isSelected 
              ? [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ] 
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected 
                    ? Colors.white 
                    : AppTheme.textSecondary,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: isSelected 
                    ? Colors.white 
                    : AppTheme.textSecondary,
                fontWeight: isSelected 
                    ? FontWeight.w600 
                    : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 