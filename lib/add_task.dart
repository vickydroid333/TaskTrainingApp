import 'package:flutter/material.dart';

class AddTaskBottomSheet extends StatelessWidget {
  const AddTaskBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextField(
          decoration: InputDecoration(
            hintText: 'New Task...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          autofocus: true,
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.star_border, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.access_time, color: Colors.grey),
              onPressed: () {},
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // Add task logic here
                Navigator.pop(context);
              },
              child: const Text(
                'Add Task',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
