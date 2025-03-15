import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:a_play_world/presentation/pages/bookings/screens/bookings_page.dart';
import 'package:a_play_world/presentation/pages/explore/screens/explore_page.dart';
import 'package:a_play_world/presentation/pages/home/home_page.dart';
import 'package:a_play_world/presentation/pages/feeds/feeds_page.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class BottomNavigation extends ConsumerStatefulWidget {
  const BottomNavigation({super.key});

  @override
  ConsumerState<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation> {
  final List<Widget> _pages = [
    const HomePage(),
    const ExplorePage(),
    const BookingsPage(),
    const FeedsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final navBarHeight = 56.0 + bottomPadding + 16.0;

    return Scaffold(
      body: Stack(
        children: [
          // Pages with bottom padding
          Positioned.fill(
            bottom: navBarHeight,
            child: IndexedStack(
              index: currentIndex,
              children: _pages,
            ),
          ),

          // Gradient Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: navBarHeight,
              color: Colors.black45,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavBarItem(
                        icon: Iconsax.home_2,
                        selectedIcon: Iconsax.home_25,
                        label: 'Home',
                        isSelected: currentIndex == 0,
                        onTap: () => ref.read(navigationIndexProvider.notifier).state = 0,
                      ),
                      _NavBarItem(
                        icon: Iconsax.discover_1,
                        selectedIcon: Iconsax.discover5,
                        label: 'Explore',
                        isSelected: currentIndex == 1,
                        onTap: () => ref.read(navigationIndexProvider.notifier).state = 1,
                      ),
                      _NavBarItem(
                        icon: Iconsax.ticket,
                        selectedIcon: Iconsax.ticket_star5,
                        label: 'Bookings',
                        isSelected: currentIndex == 2,
                        onTap: () => ref.read(navigationIndexProvider.notifier).state = 2,
                      ),
                      _NavBarItem(
                        icon: Iconsax.message,
                        selectedIcon: Iconsax.message5,
                        label: 'Feeds',
                        isSelected: currentIndex == 3,
                        onTap: () => ref.read(navigationIndexProvider.notifier).state = 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white70,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
