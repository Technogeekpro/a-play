import 'package:a_play/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:a_play/presentation/pages/concierge/screens/service_detail_page.dart';

class ConciergePage extends StatelessWidget {
  const ConciergePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.surfaceDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              title: const Text('Concierge Services'),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.message_question),
                onPressed: () {
                  // TODO: Implement live chat support
                },
              ),
            ],
          ),

          // Welcome Message
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, how can we help?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a service category below',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // Service Categories Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildListDelegate([
                _buildServiceCard(
                  context,
                  title: 'Travel',
                  icon: Iconsax.airplane,
                  description: 'Flights, transfers, and transport services',
                  color: Colors.blue,
                  services: [
                    const ServiceItem(
                      name: 'Flight Bookings',
                      icon: Iconsax.airplane,
                      description: 'Book and manage your flights',
                      features: [
                        'International & domestic flights',
                        'Flight changes & cancellations',
                        'Special assistance requests',
                        'Seat selection & upgrades',
                      ],
                    ),
                    const ServiceItem(
                      name: 'Airport Transfers',
                      icon: Iconsax.car,
                      description: 'Reliable airport pickup and drop-off',
                      features: [
                        'Professional chauffeurs',
                        'Flight tracking',
                        'Meet & greet service',
                        'Luxury vehicle options',
                      ],
                    ),
                    const ServiceItem(
                      name: 'Car Rentals',
                      icon: Iconsax.car,
                      description: 'Rent vehicles for your journey',
                      features: [
                        'Wide range of vehicles',
                        'Flexible rental periods',
                        'Insurance coverage',
                        'GPS navigation',
                      ],
                    ),
                    const ServiceItem(
                      name: 'Visa Assistance',
                      icon: Iconsax.document,
                      description: 'Help with visa applications',
                      features: [
                        'Document preparation',
                        'Application assistance',
                        'Status tracking',
                        'Express processing',
                      ],
                    ),
                  ],
                ),
                _buildServiceCard(
                  context,
                  title: 'Events',
                  icon: Iconsax.calendar,
                  description: 'Bookings, tickets, and reservations',
                  color: Colors.purple,
                  services: [
                    const ServiceItem(
                      name: 'Event Tickets',
                      icon: Iconsax.ticket,
                      description: 'Access to exclusive events',
                      features: [
                        'Concert tickets',
                        'Sports events',
                        'Theater shows',
                        'VIP packages',
                      ],
                    ),
                    const ServiceItem(
                      name: 'Restaurant Reservations',
                      icon: Iconsax.coffee,
                      description: 'Book tables at top restaurants',
                      features: [
                        'Fine dining establishments',
                        'Special occasion planning',
                        'Dietary accommodations',
                        'Private dining rooms',
                      ],
                    ),
                  ],
                ),
                _buildServiceCard(
                  context,
                  title: 'Personal',
                  icon: Iconsax.user_tick,
                  description: 'Shopping, errands, and lifestyle',
                  color: Colors.orange,
                  services: [
                    const ServiceItem(
                      name: 'Personal Shopping',
                      icon: Iconsax.shopping_cart,
                      description: 'Customized shopping assistance',
                      features: [
                        'Gift shopping',
                        'Wardrobe consultation',
                        'Personal styling',
                        'Product sourcing',
                      ],
                    ),
                    const ServiceItem(
                      name: 'Home Services',
                      icon: Iconsax.home,
                      description: 'Maintenance and cleaning',
                      features: [
                        'House cleaning',
                        'Repairs & maintenance',
                        'Pest control',
                        'Garden maintenance',
                      ],
                    ),
                  ],
                ),
                _buildServiceCard(
                  context,
                  title: 'Entertainment',
                  icon: Iconsax.music,
                  description: 'VIP access and exclusive experiences',
                  color: Colors.green,
                  services: [
                    const ServiceItem(
                      name: 'VIP Experiences',
                      icon: Iconsax.crown,
                      description: 'Exclusive access and experiences',
                      features: [
                        'Private events',
                        'Celebrity meet & greets',
                        'Backstage access',
                        'VIP club entry',
                      ],
                    ),
                  ],
                ),
                _buildServiceCard(
                  context,
                  title: 'Business',
                  icon: Iconsax.briefcase,
                  description: 'Professional and office support',
                  color: Colors.red,
                  services: [
                    const ServiceItem(
                      name: 'Meeting Arrangements',
                      icon: Iconsax.people,
                      description: 'Professional meeting support',
                      features: [
                        'Venue booking',
                        'Catering services',
                        'Equipment setup',
                        'Virtual meeting support',
                      ],
                    ),
                  ],
                ),
                _buildServiceCard(
                  context,
                  title: 'Special',
                  icon: Iconsax.magic_star,
                  description: 'Custom requests and emergencies',
                  color: Colors.teal,
                  services: [
                    const ServiceItem(
                      name: 'Emergency Support',
                      icon: Iconsax.shield_tick,
                      description: '24/7 emergency assistance',
                      features: [
                        'Medical assistance',
                        'Lost item recovery',
                        'Emergency transport',
                        'Crisis management',
                      ],
                    ),
                  ],
                ),
              ]),
            ),
          ),

          // Quick Actions Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuickActionButton(
                    context,
                    icon: Iconsax.message_text_1,
                    title: 'Live Chat Support',
                    subtitle: '24/7 assistance available',
                  ),
                  const SizedBox(height: 12),
                  _buildQuickActionButton(
                    context,
                    icon: Iconsax.call,
                    title: 'Request Callback',
                    subtitle: 'Schedule a consultation',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String description,
    required Color color,
    required List<ServiceItem> services,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailPage(
                title: title,
                icon: icon,
                color: color,
                services: services,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // TODO: Implement quick action
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Iconsax.arrow_right_3,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 