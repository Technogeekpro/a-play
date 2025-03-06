import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a_play_world/data/models/event/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final exploreControllerProvider = StateNotifierProvider<ExploreController, ExploreState>((ref) {
  return ExploreController();
});

class ExploreController extends StateNotifier<ExploreState> {
  ExploreController() : super(ExploreState.initial());

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.toLowerCase());
  }

  void updateSelectedCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  List<EventModel> filterEvents(List<EventModel> events) {
    return events.where((event) {
      if (state.searchQuery.isNotEmpty) {
        final title = event.title.toLowerCase();
        final location = event.location.toLowerCase();
        if (!title.contains(state.searchQuery) && !location.contains(state.searchQuery)) {
          return false;
        }
      }

      if (state.selectedCategory != null && state.selectedCategory != 'All') {
        if (event.categoryId != state.selectedCategory) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  Future<List<String>> fetchCategories() async {
    try {
      final response = await Supabase.instance.client.from('categories').select('name');
      return List<String>.from(response.map((category) => category['name']));
    } catch (e) {
      return defaultCategories;
    }
  }

  static const List<String> defaultCategories = [
    'All',
    'Sports',
    'Music',
    'Arts',
    'Food',
    'Education',
    'Technology',
    'Business',
    'Health',
  ];
}

class ExploreState {
  final String searchQuery;
  final String? selectedCategory;

  ExploreState({
    required this.searchQuery,
    this.selectedCategory,
  });

  factory ExploreState.initial() {
    return ExploreState(
      searchQuery: '',
      selectedCategory: null,
    );
  }

  ExploreState copyWith({
    String? searchQuery,
    String? selectedCategory,
  }) {
    return ExploreState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
