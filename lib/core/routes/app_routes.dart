import 'package:go_router/go_router.dart';
import 'package:a_play_world/presentation/pages/auth/login_page.dart';
import 'package:a_play_world/presentation/pages/navbar/bottom_navigation.dart';
import 'package:a_play_world/presentation/pages/events/detail/event_detail_page.dart';
import 'package:a_play_world/presentation/pages/events/tickets/ticket_selection_page.dart';
import 'package:a_play_world/presentation/pages/events/checkout/checkout_page.dart';
import 'package:a_play_world/presentation/pages/events/checkout/booking_success_page.dart';
import 'package:a_play_world/core/routes/route_guard.dart';
import 'package:a_play_world/data/models/event/event_model.dart';
import 'package:a_play_world/presentation/pages/search/search_screen.dart';
import 'package:a_play_world/presentation/pages/feeds/feeds_page.dart';
import 'package:a_play_world/presentation/pages/location/location_selection_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  redirect: RouteGuard.redirectIfNotAuthenticated,
  routes: [
    // Auth Routes
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),

    // Main App Routes
    GoRoute(
      path: '/',
      builder: (context, state) => const BottomNavigation(),
    ),

    // Event Detail Route
    GoRoute(
      path: '/event/:id',
      name: 'event-detail',
      builder: (context, state) {
        final event = state.extra as EventModel;
        return EventDetailPage(event: event);
      },
    ),

    // Ticket Selection Route
    GoRoute(
      path: '/tickets/:eventId',
      name: 'ticket-selection',
      builder: (context, state) {
        final event = state.extra as EventModel;
        return TicketSelectionPage(event: event);
      },
    ),

    // Checkout Route
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) {
        final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return CheckoutPage(
          event: args['event'] as EventModel,
          selectedTickets: args['tickets'] as List<Map<String, dynamic>>,
       //   totalAmount: args['totalAmount'] as num,
        );
      },
    ),

    // Booking Success Route
    GoRoute(
      path: '/booking-success',
      name: 'booking-success',
      builder: (context, state) {
        final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return BookingSuccessPage(
          event: args['event'] as EventModel,
          reference: args['reference'] as String,
        );
      },
    ),

    // Search Route
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),

    // Feeds Route
    GoRoute(
      path: '/feeds',
      name: 'feeds',
      builder: (context, state) => const FeedsPage(),
    ),
    
    // Location Selection Route
    GoRoute(
      path: '/location',
      name: 'location',
      builder: (context, state) => const LocationSelectionScreen(),
    ),
  ],
); 