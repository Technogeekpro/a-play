part of '../ticket_selection_page.dart';

class TicketTypeFilter extends StatelessWidget {
  final List<String> ticketTypes;
  final String? selectedType;
  final ValueChanged<String?> onFilterChanged;

  const TicketTypeFilter({
    super.key,
    required this.ticketTypes,
    required this.selectedType,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: selectedType == null,
            onSelected: (_) => onFilterChanged(null),
          ),
          const SizedBox(width: 8),
          ...ticketTypes.map((type) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(type),
              selected: type == selectedType,
              onSelected: (_) => onFilterChanged(type),
            ),
          )),
        ],
      ),
    );
  }
} 