import 'package:a_play_world/data/models/event/event_model.dart';
import 'package:a_play_world/presentation/pages/auth/signup.dart';
import 'package:a_play_world/presentation/pages/home/screens/search_screen.dart';
import 'package:a_play_world/presentation/pages/navbar/bottom_navigation.dart';
import 'package:a_play_world/presentation/pages/profile/screens/profile_page.dart';
import 'package:go_router/go_router.dart';
import 'package:a_play_world/presentation/pages/home/home_page.dart';
import 'package:a_play_world/presentation/pages/auth/login_page.dart';
import 'package:a_play_world/presentation/pages/events/detail/event_detail_page.dart';
import 'package:a_play_world/presentation/pages/events/tickets/ticket_selection_page.dart';
import 'package:a_play_world/presentation/pages/events/checkout/checkout_page.dart';
import 'package:a_play_world/presentation/pages/events/checkout/booking_success_page.dart';
import 'package:a_play_world/presentation/routes/route_guard.dart';
import 'package:a_play_world/presentation/pages/splash/splash_screen.dart';
import 'package:a_play_world/presentation/pages/bookings/screens/bookings_page.dart';
import 'package:a_play_world/presentation/pages/home/screens/category_events_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  redirect: RouteGuard.redirectIfNotAuthenticated,
  routes: [
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'navbar',
      builder: (context, state) => const BottomNavigation(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/event/:id',
      name: 'event-detail',
      builder: (context, state) => EventDetailPage(
        event: state.extra as EventModel,
      ),
    ),
    GoRoute(
      path: '/tickets/:eventId',
      name: 'ticket-selection',
      builder: (context, state) {
        final eventJson = state.extra as Map<String, dynamic>;
        final event = EventModel.fromJson(eventJson);
        return TicketSelectionPage(event: event);
      },
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return CheckoutPage(
          event: args['event'] as EventModel,
          selectedTickets: (args['selectedTickets'] as List<dynamic>)
              .cast<Map<String, dynamic>>(),
          //  totalAmount: args['totalAmount'] as num,
        );
      },
    ),
    GoRoute(
      path: '/booking-success',
      name: 'booking-success',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return BookingSuccessPage(
          event: args['event'] as EventModel,
          reference: args['reference'] as String,
        );
      },
    ),
    GoRoute(
      path: '/bookings',
      name: 'bookings',
      builder: (context, state) => const BookingsPage(),
    ),
    GoRoute(
      path: '/category-events',
      name: 'category-events',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return CategoryEventsPage(
          title: args['title'] as String,
          events: (args['events'] as List<dynamic>).cast<EventModel>(),
        );
      },
    ),
  ],
);
