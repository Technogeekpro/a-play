import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:a_play/presentation/pages/bookings/screens/bookings_page.dart';
import 'package:a_play/presentation/pages/explore/screens/explore_page.dart';
import 'package:a_play/presentation/pages/home/home_page.dart';
import 'package:a_play/presentation/pages/feeds/feeds_page.dart';
import 'package:a_play/presentation/pages/concierge/screens/concierge_page.dart';
import 'package:a_play/presentation/theme/app_theme.dart';

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
    const ConciergePage(),
    const FeedsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      floatingActionButton: Container(
        height: 64,
        width: 64,
        margin: const EdgeInsets.only(top: 30),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            currentIndex == 0 ? Iconsax.home_25 : Iconsax.home_2,
            size: 28,
            color: Colors.white,
          ),
          onPressed: () => ref.read(navigationIndexProvider.notifier).state = 0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomAppBar(
          height: 60 + bottomPadding,
          padding: EdgeInsets.only(bottom: bottomPadding),
          notchMargin: 8,
          color: AppTheme.surfaceDark,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
              const SizedBox(width: 80), // Space for FAB
              _NavBarItem(
                icon: Iconsax.crown,
                selectedIcon: Iconsax.crown5,
                label: 'Concierge',
                isSelected: currentIndex == 3,
                onTap: () => ref.read(navigationIndexProvider.notifier).state = 3,
              ),
              _NavBarItem(
                icon: Iconsax.message,
                selectedIcon: Iconsax.message5,
                label: 'Feeds',
                isSelected: currentIndex == 4,
                onTap: () => ref.read(navigationIndexProvider.notifier).state = 4,
              ),
            ],
          ),
        ),
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
        width: 70,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
