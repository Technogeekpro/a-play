part of '../ticket_selection_page.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.ticketType,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'GHS ${ticket.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                _buildQuantitySelector(context),
              ],
            ),
            const SizedBox(height: 8),
            _buildAvailabilityInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed:
              quantity > 0 ? () => onQuantityChanged(quantity - 1) : null,
        ),
        SizedBox(
          width: 40,
          child: Text(
            quantity.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: quantity < ticket.availableQuantity
              ? () => onQuantityChanged(quantity + 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildAvailabilityInfo(BuildContext context) {
    final availableText = ticket.availableQuantity > 0
        ? '${ticket.availableQuantity} tickets available'
        : 'Sold out';

    final textColor = ticket.availableQuantity > 0
        ? ticket.availableQuantity <= 5
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.onSurfaceVariant
        : Theme.of(context).colorScheme.error;

    return Text(
      availableText,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: textColor,
          ),
    );
  }
}
