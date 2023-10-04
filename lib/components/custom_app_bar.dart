import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../resources/app_color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback leftPressed;
  final String title;
  const CustomAppBar({
    super.key,
    required this.title, required this.leftPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(
          top: MediaQuery.of(context).padding.top + 8,
          bottom: MediaQuery.of(context).padding.bottom + 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: leftPressed,
            child: Transform.rotate(
              angle: 45 * (math.pi / 180),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.shadow,
                        offset: Offset(3.3, 3.3),
                        blurRadius: 6,
                      )
                    ]),
                child: Transform.rotate(
                  angle: -45 * (math.pi / 180),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColor.brown,
                  ),
                ),
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: AppColor.blue, fontSize: 20),
          ),

          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo.png'),
          )


        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
