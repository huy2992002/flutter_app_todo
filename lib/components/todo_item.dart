import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../resources/app_color.dart';

class TodoItem extends StatelessWidget {
  final VoidCallback? onChanged;
  final VoidCallback? onDeleted;
  final TodoModel todo;

  const TodoItem({
    super.key,
    this.onChanged,
    this.onDeleted,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
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
            Icon(
              () {
                if (todo.isDone ?? false) {
                  return Icons.check_box_outlined;
                }
                return Icons.check_box_outline_blank;
              }(),
              size: 16.8,
              color: AppColor.blue,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.6, right: 4.6),
                child: Text(
                  todo.text ?? '-:-',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: todo.isDone ?? false
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDeleted,
              child: const Padding(
                padding: EdgeInsets.all(6.0),
                child: CircleAvatar(
                  backgroundColor: AppColor.orange,
                  radius: 12.0,
                  child: Icon(Icons.delete, size: 14.0, color: AppColor.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

