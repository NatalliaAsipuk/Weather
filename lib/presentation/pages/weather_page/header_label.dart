import 'package:flutter/material.dart';
import 'package:weather/presentation/app_colors.dart';

class HeaderLabel extends StatelessWidget {
  const HeaderLabel({
    super.key,
    required this.label,
    this.size = 30,
  });

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.primaryTextColor,
          fontSize: size,
        ),
      ),
    );
  }
}