import 'package:flutter/material.dart';
import 'package:a_play_world/core/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class HomeAppBarSection extends StatelessWidget {
  const HomeAppBarSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App Logo in svg

          GestureDetector(
            onTap: () {
              //Navigate to profile page
              Navigator.pushNamed(context, '/profile');
            },
            child: SvgPicture.asset(
              'assets/images/app_logo.svg',
              height: 35,
            ),
          ),

          // Profile Avatar
          GestureDetector(
            onTap: () {
              // Navigate to profile or open menu
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
