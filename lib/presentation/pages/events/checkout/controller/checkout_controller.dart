import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a_play/data/models/event/event_model.dart';
import 'package:a_play/data/models/ticket/ticket_model.dart';
import 'package:a_play/core/config/supabase_config.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:flutter/material.dart';

/// State class for checkout process
class CheckoutState {
  final bool isLoading;
  final String? error;
  final String? paymentUrl;
  final String? bookingReference;
  final String? bookingId;
  final double totalAmount;
  final List<Map<String, dynamic>> selectedTickets;
  final bool isPaymentSuccessful;
  final bool isBookingCreated;

  const CheckoutState({
    this.isLoading = false,
    this.error,
    this.paymentUrl,
    this.bookingReference,
    this.bookingId,
    this.totalAmount = 0.0,
    this.selectedTickets = const [],
    this.isPaymentSuccessful = false,
    this.isBookingCreated = false,
  });

  CheckoutState copyWith({
    bool? isLoading,
    String? error,
    String? paymentUrl,
    String? bookingReference,
    String? bookingId,
    double? totalAmount,
    List<Map<String, dynamic>>? selectedTickets,
    bool? isPaymentSuccessful,
    bool? isBookingCreated,
  }) {
    return CheckoutState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      bookingReference: bookingReference ?? this.bookingReference,
      bookingId: bookingId ?? this.bookingId,
      totalAmount: totalAmount ?? this.totalAmount,
      selectedTickets: selectedTickets ?? this.selectedTickets,
      isPaymentSuccessful: isPaymentSuccessful ?? this.isPaymentSuccessful,
      isBookingCreated: isBookingCreated ?? this.isBookingCreated,
    );
  }
}

/// Provider for the checkout controller
final checkoutControllerProvider = StateNotifierProvider.autoDispose<CheckoutController, CheckoutState>((ref) {
  return CheckoutController();
});

class CheckoutController extends StateNotifier<CheckoutState> {
  CheckoutController() : super(const CheckoutState());

  /// Initialize checkout with selected tickets
  void initializeCheckout(List<Map<String, dynamic>> selectedTickets) {
    final totalAmount = selectedTickets.fold<double>(
      0.0,
      (total, ticket) => total + (ticket['ticket'].price * ticket['quantity']),
    );

    state = state.copyWith(
      selectedTickets: selectedTickets,
      totalAmount: totalAmount,
      error: null,
      isPaymentSuccessful: false,
      isBookingCreated: false,
      bookingId: null,
      bookingReference: null,
    );
  }

  /// Create a booking in the database
  Future<void> createBooking(String userId, EventModel event, BuildContext context) async {
    try {
      // Check if booking is already created
      if (state.isBookingCreated) {
        // If booking exists but payment failed, retry payment
        if (!state.isPaymentSuccessful && state.bookingReference != null) {
          final user = SupabaseConfig.client.auth.currentUser;
          if (user?.email != null) {
            await initializePayment(state.bookingReference!, user!.email!, context);
          }
        }
        return;
      }

      state = state.copyWith(isLoading: true, error: null);

      // Get the first ticket data to use its ID
      final firstTicket = state.selectedTickets.first;
      final ticket = firstTicket['ticket'] as TicketModel;
      final quantity = firstTicket['quantity'] as int;

      // Get user details from Supabase
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) throw Exception('User not found');
      if (user.email == null) throw Exception('User email is required for payment');

      // Check if user exists in the users table
      final userResponse = await SupabaseConfig.client
          .from('users')
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      // If user doesn't exist, create the user record
      if (userResponse == null) {
        debugPrint('User not found in users table. Creating user record.');
        await SupabaseConfig.client.from('users').insert({
          'id': userId,
          'email': user.email,
          'full_name': user.userMetadata?['full_name'] ?? 'Unknown',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        debugPrint('User record created successfully.');
      }

      // Generate a unique booking reference
      final bookingReference = 'BK${DateTime.now().millisecondsSinceEpoch}';

      // Create the booking record matching BookingModel structure
      final bookingData = {
        'user_id': userId,
        'event_id': event.id,
        'ticket_id': ticket.id,
        'quantity': quantity,
        'total_amount': state.totalAmount,
        'status': 'pending',
        'payment_status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'customer_name': user.userMetadata?['full_name'] ?? 'Unknown',
        'customer_email': user.email!,
        'customer_phone': user.phone ?? '',
        'tickets': state.selectedTickets.map((ticketData) {
          final t = ticketData['ticket'] as TicketModel;
          final q = ticketData['quantity'] as int;
          return {
            'ticket_id': t.id,
            'quantity': q,
            'unit_price': t.price,
            'subtotal': t.price * q,
          };
        }).toList(),
      };
      
      // Insert the booking and get the response
      final response = await SupabaseConfig.client
          .from('bookings')
          .insert(bookingData)
          .select()
          .single();

      // Store both booking reference and ID
      state = state.copyWith(
        bookingReference: bookingReference,
        bookingId: response['id'].toString(),
        isBookingCreated: true,
      );

      // Initialize payment after booking is created
      await initializePayment(bookingReference, user.email!, context);

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create booking: $e',
      );
    }
  }

  /// Initialize payment process
  Future<void> initializePayment(String bookingReference, String email, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      debugPrint('Initializing payment for booking: $bookingReference');
      debugPrint('Amount to charge: ${state.totalAmount * 100} pesewas');

      final paystack = PayWithPayStack();
      await paystack.now(
        context: context,
        secretKey: 'sk_test_70842d023228e49e589ab527b2040863b39a4446',
        customerEmail: email,
        reference: bookingReference,
        currency: 'GHS',
        amount: state.totalAmount * 100, // Convert to pesewas
        callbackUrl: 'https://your-domain.com/payment/callback',
        transactionCompleted: (data) async {
          debugPrint('Payment completed: ${data.toString()}');
          try {
            await updateBookingAfterPayment(data.reference ?? bookingReference);
            // Update state after successful payment and booking update
            state = state.copyWith(
              isPaymentSuccessful: true,
              isLoading: false,
              error: null,
            );
            // Don't pop here, let the checkout page handle navigation
          } catch (e) {
            debugPrint('Error updating booking after payment: $e');
            state = state.copyWith(
              isLoading: false,
              error: 'Payment successful but failed to update booking: $e',
              isPaymentSuccessful: false,
            );
          }
        },
        transactionNotCompleted: (data) {
          debugPrint('Payment not completed: ${data.toString()}');
          state = state.copyWith(
            error: 'Payment not completed. Please try again.',
            isLoading: false,
            isPaymentSuccessful: false,
          );
        },
      );

      debugPrint('Payment initialized successfully');

    } catch (e) {
      debugPrint('Payment error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize payment: $e',
        isPaymentSuccessful: false,
      );
      // Cancel the booking if payment initialization fails
      if (state.bookingId != null) {
        await cancelBooking();
      }
    }
  }

  /// Update booking after successful payment
  Future<void> updateBookingAfterPayment(String reference) async {
    final bookingId = state.bookingId;
    if (bookingId == null) {
      debugPrint('No booking ID found for payment update');
      throw Exception('No booking ID found');
    }

    try {
      state = state.copyWith(isLoading: true, error: null);
      debugPrint('Updating booking after payment: $bookingId');

      // First verify if booking is not already confirmed
      final bookingResponse = await SupabaseConfig.client
          .from('bookings')
          .select()
          .eq('id', bookingId)
          .single();

      debugPrint('Current booking status: ${bookingResponse['status']}');

      if (bookingResponse['status'] == 'confirmed') {
        debugPrint('Booking already confirmed');
        state = state.copyWith(
          isLoading: false,
          isPaymentSuccessful: true,
        );
        return;
      }

      // Update booking status
      await SupabaseConfig.client
          .from('bookings')
          .update({
            'status': 'confirmed',
            'payment_status': 'paid',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);

      debugPrint('Booking status updated to confirmed');

      // Update ticket quantities
      for (final ticketData in state.selectedTickets) {
        final ticket = ticketData['ticket'] as TicketModel;
        final quantity = ticketData['quantity'] as int;

        debugPrint('Updating ticket quantity - ID: ${ticket.id}, Quantity: $quantity');

        await SupabaseConfig.client
            .from('tickets')
            .update({
              'quantity_sold': ticket.soldQuantity + quantity,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', ticket.id);
      }

      debugPrint('All ticket quantities updated successfully');

      state = state.copyWith(
        isLoading: false,
        isPaymentSuccessful: true,
        error: null,
      );

    } catch (e) {
      debugPrint('Error updating booking after payment: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update booking: $e',
        isPaymentSuccessful: false,
      );
    }
  }

  /// Cancel booking
  Future<void> cancelBooking() async {
    final bookingId = state.bookingId;
    if (bookingId == null) {
      throw Exception('No booking ID found');
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      await SupabaseConfig.client
          .from('bookings')
          .update({
            'status': 'cancelled',
            'payment_status': 'cancelled',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);

      state = state.copyWith(
        isLoading: false,
        isBookingCreated: false,
        bookingId: null,
        bookingReference: null,
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to cancel booking: $e',
      );
    }
  }
}
