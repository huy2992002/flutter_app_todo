import 'package:flutter/material.dart';

import '../resources/app_color.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChange;
  const SearchBox({super.key, this.controller, this.onChange,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppColor.shadow,
            offset: Offset(3.3, 3.3),
            blurRadius: 6,
          )
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          controller: controller,
          onChanged: onChange,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: AppColor.grey),
            prefixIcon: Icon(Icons.search)
          ),
        ),
      ),
    );
  }
}