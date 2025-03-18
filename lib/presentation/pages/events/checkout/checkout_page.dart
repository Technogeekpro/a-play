import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:a_play/data/models/event/event_model.dart';
import 'package:a_play/data/models/ticket/ticket_model.dart';
import 'package:a_play/presentation/pages/events/checkout/controller/checkout_controller.dart';
import 'package:a_play/presentation/pages/auth/controller/auth_controller.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  final EventModel event;
  final List<Map<String, dynamic>> selectedTickets;

  const CheckoutPage({
    super.key,
    required this.event,
    required this.selectedTickets,
  });

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  @override
  void initState() {
    super.initState();
    // Initialize checkout with selected tickets
    Future.microtask(() {
      ref.read(checkoutControllerProvider.notifier).initializeCheckout(widget.selectedTickets);
    });
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutControllerProvider);
    final user = ref.watch(authControllerProvider).value;

    // Listen for payment success and navigate
    ref.listen<CheckoutState>(
      checkoutControllerProvider,
      (previous, current) {
        if (current.isPaymentSuccessful && current.bookingReference != null) {
          // Navigate to success page without popping
          context.pushReplacement(
            '/booking-success',
            extra: {
              'event': widget.event,
              'reference': current.bookingReference,
            },
          );
        } else if (current.error != null && !current.isLoading) {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(

              content: Text(current.error!,style: const TextStyle(
                color: Colors.white
              ),),
              backgroundColor: Theme.of(context).colorScheme.error,

              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.black,
                onPressed: () {
                  if (user != null) {
                    ref
                        .read(checkoutControllerProvider.notifier)
                        .createBooking(user.id, widget.event, context);
                  }
                },
              ),
            ),
          );
        }
      },
    );

    return WillPopScope(
      // Prevent back navigation during payment processing
      onWillPop: () async => !checkoutState.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
        ),
        body: checkoutState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Details Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.event.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.event.formattedStartDate,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              widget.event.location,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Selected Tickets
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Tickets',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            ...widget.selectedTickets.map((ticketData) {
                              final ticket = ticketData['ticket'] as TicketModel;
                              final quantity = ticketData['quantity'] as int;
                              final subtotal = ticket.price * quantity;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ticket.ticketType,
                                            style: Theme.of(context).textTheme.titleSmall,
                                          ),
                                          Text(
                                            '${ticket.formattedPrice} × $quantity',
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'GHS ${subtotal.toStringAsFixed(2)}',
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  'GHS ${checkoutState.totalAmount.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Error Message
                    if (checkoutState.error != null)
                      Card(
                        color: Theme.of(context).colorScheme.secondary,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  checkoutState.error!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Checkout Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: checkoutState.isLoading
                            ? null
                            : () async {
                                if (user == null) {
                                  context.go('/login');
                                  return;
                                }

                                await ref
                                    .read(checkoutControllerProvider.notifier)
                                    .createBooking(user.id, widget.event, context);
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            checkoutState.isLoading ? 'Processing...' : 'Pay Now',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
