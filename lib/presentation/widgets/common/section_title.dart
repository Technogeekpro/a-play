import 'package:flutter/material.dart';
import 'package:a_play/core/theme/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry padding;
  

  const SectionTitle({
    super.key,
    required this.title,
    this.padding = const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
    
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                right: 16
              ),
              height: 1,
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Colors.white.withAlpha(80), Colors.white.withAlpha(0)],
              )),
            ),
          ),
          Text(
            title,
            style: AppTextStyles.headingMedium(),
          ),
           Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 16
              ),
              height: 1,
              decoration:  BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.white.withAlpha(80), Colors.white.withAlpha(0)],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
