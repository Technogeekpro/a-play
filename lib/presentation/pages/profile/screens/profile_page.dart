import 'package:a_play_world/presentation/pages/auth/controller/auth_controller.dart';
import 'package:a_play_world/presentation/pages/profile/screens/contact_us_page.dart';
import 'package:a_play_world/presentation/pages/profile/screens/help_support_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a_play_world/presentation/pages/profile/controller/user_controller.dart';
import 'package:a_play_world/presentation/pages/profile/screens/edit_profile_page.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: userState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error loading profile: ${error.toString()}',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No user data available'));
          }

          return CustomScrollView(
            slivers: [
              // App Bar with User Info
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: Theme.of(context).colorScheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primaryContainer,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'profile-image',
                            child: GestureDetector(
                              onTap: () {
                                if (user.avatarUrl != null) {
                                  debugPrint('Avatar URL: ${user.avatarUrl}');
                                }
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: ClipOval(
                                  child: user.avatarUrl != null &&
                                          user.avatarUrl!.isNotEmpty
                                      ? Image.network(
                                          user.avatarUrl!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            debugPrint(
                                                'Error loading image: $error');
                                            debugPrint(
                                                'Attempted URL: ${user.avatarUrl}');
                                            return Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            );
                                          },
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.fullName ?? 'User',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            user.email,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.8),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Booking Stats
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Statistics',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatItem(
                                  context,
                                  'Total Bookings',
                                  '12',
                                  Icons.confirmation_number_outlined,
                                ),
                              ),
                              Expanded(
                                child: _buildStatItem(
                                  context,
                                  'Upcoming',
                                  '3',
                                  Icons.upcoming_outlined,
                                ),
                              ),
                              Expanded(
                                child: _buildStatItem(
                                  context,
                                  'Completed',
                                  '9',
                                  Icons.event_available_outlined,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Profile Actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Settings',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Column(
                          children: [
                            _buildActionTile(
                              context,
                              'Edit Profile',
                              Icons.edit_outlined,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfilePage(user: user),
                                ),
                              ),
                            ),
                            _buildActionTile(
                              context,
                              'My Bookings',
                              Icons.confirmation_number_outlined,
                              onTap: () => context.push('/bookings'),
                            ),
                            _buildActionTile(
                              context,
                              'Help & Support',
                              Icons.help_outline,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpSupportPage(),
                                ),
                              ),
                            ),
                            _buildActionTile(
                              context,
                              'Contact Us',
                              Icons.mail_outline,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ContactUsPage(),
                                ),
                              ),
                            ),
                            _buildActionTile(
                              context,
                              'About',
                              Icons.info_outline,
                              onTap: () => _showAboutDialog(context),
                            ),
                            _buildActionTile(
                              context,
                              'Logout',
                              Icons.logout,
                              textColor: Theme.of(context).colorScheme.error,
                              iconColor: Theme.of(context).colorScheme.error,
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text(
                                      'Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ref
                                            .read(
                                                authControllerProvider.notifier)
                                            .signOut();
                                        context.go('/login');
                                      },
                                      child: Text(
                                        'Logout',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: textColor,
            ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AboutDialog(
        applicationName: 'A Play World',
        applicationVersion: '1.0.0',
        applicationIcon: FlutterLogo(size: 50),
        children: [
          Text(
            'A Play World is your one-stop destination for discovering and booking exciting events. Join us in making every moment memorable!',
          ),
        ],
      ),
    );
  }
}
