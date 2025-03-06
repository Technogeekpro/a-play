import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:a_play_world/data/models/event/event_model.dart';
import 'package:a_play_world/data/models/ticket/ticket_model.dart';
import 'package:a_play_world/presentation/pages/events/tickets/controller/ticket_controller.dart';

part 'widgets/event_info_card.dart';
part 'widgets/ticket_card.dart';
part 'widgets/ticket_type_filter.dart';
part 'widgets/bottom_bar.dart';

class TicketSelectionPage extends ConsumerStatefulWidget {
  final EventModel event;

  const TicketSelectionPage({
    super.key,
    required this.event,
  });

  @override
  ConsumerState<TicketSelectionPage> createState() => _TicketSelectionPageState();
}

class _TicketSelectionPageState extends ConsumerState<TicketSelectionPage> {
  String? _selectedType;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Fetch tickets when the page loads
    Future.microtask(() {
      ref.read(ticketControllerProvider.notifier).fetchTickets(widget.event.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticketsAsync = ref.watch(ticketControllerProvider);
    final selectedTickets = ref.watch(selectedTicketsProvider);
    final totalAmount = ref.watch(totalAmountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Tickets'),
      ),
      body: ticketsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error loading tickets',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(ticketControllerProvider.notifier).fetchTickets(widget.event.id),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
        data: (tickets) {
          if (tickets.isEmpty) {
            return const Center(child: Text('No tickets available'));
          }

          final ticketTypes = ref.read(ticketControllerProvider.notifier).getTicketTypes();
          final filteredTickets = ref.read(ticketControllerProvider.notifier).getFilteredTickets(_selectedType);

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    EventInfoCard(event: widget.event),
                    const SizedBox(height: 16),
                    TicketTypeFilter(
                      ticketTypes: ticketTypes,
                      selectedType: _selectedType,
                      onFilterChanged: (type) {
                        setState(() {
                          _selectedType = type;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ...filteredTickets.map((ticket) => TicketCard(
                      ticket: ticket,
                      quantity: selectedTickets[ticket.id] ?? 0,
                      onQuantityChanged: (quantity) {
                        ref.read(ticketControllerProvider.notifier)
                            .updateTicketQuantity(ticket.id, quantity, ref);
                      },
                    )),
                  ],
                ),
              ),
              BottomBar(
                totalAmount: totalAmount,
                hasSelectedTickets: selectedTickets.isNotEmpty,
                onContinue: _isProcessing ? null : () => _handleContinue(tickets),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleContinue(List<TicketModel> tickets) async {
    final selectedTickets = ref.read(selectedTicketsProvider);
    if (selectedTickets.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      final selectedTicketDetails = selectedTickets.entries.map((entry) {
        final ticket = tickets.firstWhere((t) => t.id == entry.key);
        return {
          'ticket': ticket,
          'quantity': entry.value,
        };
      }).toList();

      if (mounted) {
        context.pushNamed(
          'checkout',
          extra: {
            'event': widget.event,
            'selectedTickets': selectedTicketDetails,
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  void dispose() {
    // Clear selected tickets when leaving the page
    ref.read(ticketControllerProvider.notifier).clearSelection(ref);
    super.dispose();
  }
}
