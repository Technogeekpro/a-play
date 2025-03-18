import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_play/presentation/pages/home/controller/home_controller.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

// State notifier for search pagination
final searchPaginationProvider = StateNotifierProvider<SearchPaginationNotifier, AsyncValue<List<dynamic>>>((ref) {
  return SearchPaginationNotifier();
});

class SearchPaginationNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  SearchPaginationNotifier() : super(const AsyncValue.loading());
  
  static const int _pageSize = 10;
  bool _hasMore = true;
  int _currentPage = 1;
  List<dynamic> _items = [];
  bool _isLoading = false;
  
  Future<void> loadMore(String query) async {
    if (!_hasMore || _isLoading) return;
    
    _isLoading = true;
    
    try {
      // Simulating API call with delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // TODO: Replace with actual API call using query, filters, pagination
      // Example query structure:
      // final response = await supabase
      //   .from('events')
      //   .select()
      //   .ilike('title', '%$query%')
      //   .order('created_at', ascending: false)
      //   .range(_currentPage * _pageSize, (_currentPage + 1) * _pageSize - 1);
      
      // For demo purposes, creating mock data
      final newItems = List.generate(
        10, 
        (i) => MockEvent(
          id: 'event-${_currentPage * 10 + i}',
          title: 'Event ${_currentPage * 10 + i}',
          locationName: 'Location ${_currentPage * 10 + i}',
          imageUrl: 'https://picsum.photos/seed/${_currentPage * 10 + i}/400/200',
          price: 10.0 + (_currentPage * 10 + i),
          index: _currentPage * 10 + i,
        ),
      );
      
      _items.addAll(newItems);
      _currentPage++;
      _hasMore = newItems.length == _pageSize;
      
      state = AsyncValue.data(_items);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      _isLoading = false;
    }
  }
  
  void reset() {
    _currentPage = 1;
    _items = [];
    _hasMore = true;
    _isLoading = false;
    state = const AsyncValue.loading();
  }
}

// Mock class for demonstration purposes
class MockEvent {
  final String id;
  final String title;
  final String locationName;
  final String? imageUrl;
  final double price;
  final int index;
  
  MockEvent({
    required this.id,
    required this.title,
    required this.locationName,
    required this.imageUrl,
    required this.price,
    required this.index,
  });
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [];
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  String _searchQuery = '';
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  // Filter states
  String _selectedCategory = 'All';
  RangeValues _priceRange = const RangeValues(0, 1000);
  String _sortBy = 'Relevance';
  
  final List<String> _categories = ['All', 'Music', 'Sports', 'Arts', 'Food'];
  final List<String> _sortOptions = ['Relevance', 'Price: Low to High', 'Price: High to Low', 'Date'];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _setupScrollListener();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(searchPaginationProvider.notifier).loadMore(_searchQuery);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches.addAll(prefs.getStringList('recent_searches') ?? []);
    });
  }

  Future<void> _saveRecentSearch(String query) async {
    if (query.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final searches = _recentSearches.where((s) => s != query).take(9).toList();
    searches.insert(0, query);

    await prefs.setStringList('recent_searches', searches);
    setState(() {
      _recentSearches.clear();
      _recentSearches.addAll(searches);
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query.toLowerCase();
      });
      if (query.isNotEmpty) {
        _saveRecentSearch(query);
        ref.read(searchPaginationProvider.notifier).reset();
        ref.read(searchPaginationProvider.notifier).loadMore(query);
      }
    });
  }

  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_searches');
    setState(() {
      _recentSearches.clear();
    });
  }

  Widget _buildSearchBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
              decoration: const InputDecoration(
            hintText: 'Search events...',
            border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _searchQuery.isNotEmpty ? 60 : 0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildFilterChip(
              label: _selectedCategory,
              icon: Icons.category,
              onTap: () => _showCategoryPicker(),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Price',
              icon: Icons.attach_money,
              onTap: () => _showPriceRangePicker(),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: _sortBy,
              icon: Icons.sort,
              onTap: () => _showSortOptions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 4),
              Text(label),
              const Icon(Icons.arrow_drop_down, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(dynamic event) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'event-detail',
            pathParameters: {'id': event.id},
            extra: event,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'event-image-${event.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    event.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.locationName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${event.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement booking logic
                        },
                        child: const Text('Book Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Container(
                  height: 200,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 200,
                        height: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            return ListTile(
              title: Text(category),
              selected: _selectedCategory == category,
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
                Navigator.pop(context);
                // Trigger search with new filter
                ref.read(searchPaginationProvider.notifier).reset();
                ref.read(searchPaginationProvider.notifier).loadMore(_searchQuery);
              },
            );
          },
        );
      },
    );
  }

  void _showPriceRangePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Price Range'),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 100,
                    labels: RangeLabels(
                      '\$${_priceRange.start.round()}',
                      '\$${_priceRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Trigger search with new filter
                      ref.read(searchPaginationProvider.notifier).reset();
                      ref.read(searchPaginationProvider.notifier).loadMore(_searchQuery);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _sortOptions.length,
          itemBuilder: (context, index) {
            final option = _sortOptions[index];
            return ListTile(
              title: Text(option),
              selected: _sortBy == option,
              onTap: () {
                setState(() {
                  _sortBy = option;
                });
                Navigator.pop(context);
                // Trigger search with new sorting
                ref.read(searchPaginationProvider.notifier).reset();
                ref.read(searchPaginationProvider.notifier).loadMore(_searchQuery);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(searchPaginationProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildFilterBar(),
            Expanded(
              child: events.when(
                loading: () => _buildLoadingShimmer(),
                error: (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48),
                      const SizedBox(height: 16),
                      Text('Error: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(searchPaginationProvider.notifier).reset();
                          ref.read(searchPaginationProvider.notifier).loadMore(_searchQuery);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
        data: (eventsList) {
          if (_searchQuery.isEmpty && _recentSearches.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Searches',
                        style: TextStyle(
                                  fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _clearRecentSearches,
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                          child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: _recentSearches.length,
                    itemBuilder: (context, index) {
                      final search = _recentSearches[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(search),
                        onTap: () {
                          _searchController.text = search;
                          _onSearchChanged(search);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final searches = List<String>.from(_recentSearches)
                              ..removeAt(index);
                                            await prefs.setStringList('recent_searches', searches);
                            setState(() {
                              _recentSearches.removeAt(index);
                            });
                          },
                                        ),
                                      ),
                                    ),
                        ),
                      );
                    },
                            ),
                  ),
                ),
              ],
            );
          }

                  if (eventsList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'No events found for "$_searchQuery"',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return AnimationLimiter(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: eventsList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == eventsList.length) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: events.isLoading
                                  ? const CircularProgressIndicator()
                                  : const SizedBox(),
                            ),
                          );
                        }
                        
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildEventCard(eventsList[index]),
                            ),
                          ),
                      );
                    },
                  ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
