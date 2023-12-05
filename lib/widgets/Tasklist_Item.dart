import 'package:flutter/material.dart';

class Tasklist_Item extends StatelessWidget {
  Tasklist_Item({
    required this.subject,
    required this.description,
    required this.date,
    required this.type,
    required this.onEdit,
    required this.onDelete,
    this.backgroundColor,
  });

  final String subject, description, type;
  final VoidCallback onEdit, onDelete;
  final Color? backgroundColor;
  final dynamic date;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(description),
            const SizedBox(
              height: 8,
            ),
            Text('Date : $date'),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Chip(
                  label: Text(
                    type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  backgroundColor: backgroundColor,
                ),
                const Spacer(),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                  color: Colors.redAccent,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}