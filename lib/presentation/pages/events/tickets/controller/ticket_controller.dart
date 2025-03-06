import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:a_play_world/data/models/ticket/ticket_model.dart';
import 'package:a_play_world/core/config/supabase_config.dart';

/// Provider for the ticket controller
final ticketControllerProvider = StateNotifierProvider<TicketController, AsyncValue<List<TicketModel>>>((ref) {
  return TicketController();
});

/// Provider for selected ticket quantities
final selectedTicketsProvider = StateProvider<Map<String, int>>((ref) => {});

/// Provider for total amount calculation
final totalAmountProvider = Provider<double>((ref) {
  final selectedTickets = ref.watch(selectedTicketsProvider);
  final ticketsState = ref.watch(ticketControllerProvider);
  
  return ticketsState.when(
    data: (tickets) => selectedTickets.entries.fold(0.0, (total, entry) {
      final ticket = tickets.firstWhere(
        (t) => t.id == entry.key,
        orElse: () => TicketModel(
          id: '',
          price: 0,
          eventId: '',
          ticketType: '',
          availableQuantity: 0,
          soldQuantity: 0,
          saleEndsAt: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      return total + (ticket.price * entry.value);
    }),
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

class TicketController extends StateNotifier<AsyncValue<List<TicketModel>>> {
  TicketController() : super(const AsyncValue.loading());

  /// Fetches tickets for a specific event
  Future<void> fetchTickets(String eventId) async {
    try {
      state = const AsyncValue.loading();
      debugPrint('Fetching tickets for event: $eventId');
      
      final response = await SupabaseConfig.client
          .from('tickets')
          .select()
          .eq('event_id', eventId);

      debugPrint('Raw response: $response');

      final ticketsList = response as List;
      debugPrint('Found ${ticketsList.length} tickets');
      
      final tickets = ticketsList.map((json) {
        try {
          debugPrint('Processing ticket: $json');
          final safeJson = Map<String, dynamic>.from(json);
          
          // Process ticket date fields
          final now = DateTime.now().toIso8601String();
          
          // Fix the sale_ends_at field name typo
          if (safeJson['sale_end_at'] != null) {
            safeJson['sale_ends_at'] = safeJson['sale_end_at'];
          }
          
          final dateFields = ['sale_ends_at', 'created_at', 'updated_at'];
          for (final field in dateFields) {
            try {
              safeJson[field] = safeJson[field] != null 
                  ? DateTime.parse(safeJson[field]).toIso8601String()
                  : now;
            } catch (e) {
              debugPrint('Error parsing date field $field: $e');
              safeJson[field] = now;
            }
          }
          
          // Process basic ticket fields
          safeJson['id'] = safeJson['id']?.toString() ?? '';
          safeJson['name'] = safeJson['name']?.toString() ?? safeJson['ticket_type']?.toString() ?? '';
          safeJson['price'] = num.tryParse(safeJson['price']?.toString() ?? '0') ?? 0;
          safeJson['event_id'] = safeJson['event_id']?.toString() ?? eventId;
          safeJson['ticket_type'] = safeJson['ticket_type']?.toString() ?? 'General';
          safeJson['quantity_available'] = int.tryParse(safeJson['quantity_available']?.toString() ?? '0') ?? 0;
          safeJson['quantity_sold'] = int.tryParse(safeJson['quantity_sold']?.toString() ?? '0') ?? 0;

          debugPrint('Processed ticket JSON: $safeJson');
          
          final ticket = TicketModel.fromJson(safeJson);
          debugPrint('Created ticket: ${ticket.id} - ${ticket.ticketType}');
          return ticket;
        } catch (e) {
          debugPrint('Error processing ticket: $e');
          return null;
        }
      })
      .where((ticket) => ticket != null)
      .cast<TicketModel>()
      .toList();

      debugPrint('Successfully processed ${tickets.length} tickets');
      state = AsyncValue.data(tickets);
    } catch (e, stack) {
      debugPrint('Error fetching tickets: $e\n$stack');
      state = AsyncValue.error(e, stack);
    }
  }

  /// Updates the quantity of a selected ticket
  void updateTicketQuantity(String ticketId, int quantity, WidgetRef ref) {
    final selectedTickets = ref.read(selectedTicketsProvider.notifier);
    final currentSelections = Map<String, int>.from(selectedTickets.state);
    
    if (quantity <= 0) {
      currentSelections.remove(ticketId);
    } else {
      currentSelections[ticketId] = quantity;
    }
    
    selectedTickets.state = currentSelections;
  }

  /// Gets all unique ticket types
  List<String> getTicketTypes() {
    return state.when(
      data: (tickets) {
        final types = tickets.map((t) => t.ticketType).toSet().toList();
        debugPrint('Available ticket types: $types');
        return types;
      },
      loading: () => [],
      error: (_, __) => [],
    );
  }

  /// Gets filtered tickets based on selected type
  List<TicketModel> getFilteredTickets(String? selectedType) {
    return state.when(
      data: (tickets) {
        final filtered = selectedType == null
            ? tickets
            : tickets.where((t) => t.ticketType == selectedType).toList();
        debugPrint('Filtered tickets (${selectedType ?? 'all'}): ${filtered.length}');
        return filtered;
      },
      loading: () => [],
      error: (_, __) => [],
    );
  }

  /// Clears all selected tickets
  void clearSelection(WidgetRef ref) {
    ref.read(selectedTicketsProvider.notifier).state = {};
  }
}
