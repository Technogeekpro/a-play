import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


/// Custom app bar for the home page
class HomeAppBarSection extends StatelessWidget {
  const HomeAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              // App Logo
              SvgPicture.asset(
                'assets/images/app_logo.svg',
                height: 40,
                width: 80,
              ),
              const Spacer(),
              // Profile Icon
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                child: const Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
