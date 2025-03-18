import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';// Controller
import 'package:a_play/presentation/pages/home/controller/home_controller.dart';// Model // Widgets
import 'package:a_play/presentation/widgets/home/home_app_bar_section.dart';
import 'package:a_play/presentation/widgets/home/search_bar_section.dart';
import 'package:a_play/presentation/widgets/home/featured_events_section.dart';
import 'package:a_play/presentation/widgets/home/filter_buttons_section.dart';
import 'package:a_play/presentation/widgets/home/all_events_section.dart';
import 'package:a_play/presentation/widgets/common/section_title.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedFilterIndex = 0;

  // Filter options
  final List<String> _filterOptions = [
    'Today',
    'Tomorrow',
    'This Weekend',
    'Under 10 Km',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override

  /// The root widget of the home page, which displays a list of all events and a
  /// carousel of featured events.
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar with Logo and Profile
            const SliverToBoxAdapter(
              child: HomeAppBarSection(),
            ),

            // Search Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchBarDelegate(),
            ),

            // Featured Events Title
            const SliverToBoxAdapter(
              child: SectionTitle(
                title: 'Featured Events',
                padding: EdgeInsets.symmetric(
                  vertical: 24,
                ),
              ),
            ),

            // Featured Events Carousel
            eventsAsync.when(
              data: (events) {
                final featuredEvents =
                    events.where((event) => event.isFeatured).toList();

                return FeaturedEventsSection(events: featuredEvents);
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => SliverToBoxAdapter(
                child: Text('Error: $error'),
              ),
            ),

            // All Events Title
            const SliverToBoxAdapter(
              child: SectionTitle(title: 'ALL EVENTS'),
            ),

            // Filter Buttons
            SliverPersistentHeader(
              pinned: true,
              delegate: FilterButtonsDelegate(
                filterOptions: _filterOptions,
                selectedIndex: _selectedFilterIndex,
                onFilterSelected: (index) {
                  setState(() {
                    _selectedFilterIndex = index;
                  });
                },
              ),
            ),

            // All Events List
            eventsAsync.when(
              data: (events) {
                return AllEventsSection(events: events);
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => SliverToBoxAdapter(
                child: Text('Error: $error'),
              ),
            ),
          ],
        ),
      ),
    );
  } // End of build method
}

class FilterButtonsDelegate extends SliverPersistentHeaderDelegate {
  final List<String> filterOptions;
  final int selectedIndex;
  final Function(int) onFilterSelected;

  FilterButtonsDelegate({
    required this.filterOptions,
    required this.selectedIndex,
    required this.onFilterSelected,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return FilterButtonsSection(
      filterOptions: filterOptions,
      selectedIndex: selectedIndex,
      onFilterSelected: onFilterSelected,
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const SearchBarSection();
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
