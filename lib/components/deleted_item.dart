import 'package:flutter/material.dart';

import '../models/todo_model.dart';
import '../resources/app_color.dart';

class DeletedItem extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback? onDeleted;
  final VoidCallback? onRefresh;
  const DeletedItem({
    super.key,
    required this.todo,
    required this.onDeleted,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12.6)
            .copyWith(left: 14.0, right: 8.0),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: AppColor.shadow,
              offset: Offset(0.0, 3.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(child: Text(todo.text ?? '')),
            GestureDetector(
              onTap: onRefresh,
              child: const Padding(
                padding: EdgeInsets.all(6.0),
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 12.0,
                  child: Icon(Icons.refresh, size: 14.0, color: AppColor.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: onDeleted,
              child: const Padding(
                padding: EdgeInsets.all(6.0),
                child: CircleAvatar(
                  backgroundColor: AppColor.red,
                  radius: 12.0,
                  child: Icon(Icons.delete, size: 14.0, color: AppColor.white),
                ),
              ),
            ),
          ],
        ));
  }
}
