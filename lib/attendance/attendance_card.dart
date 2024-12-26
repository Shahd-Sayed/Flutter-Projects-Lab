import 'package:flutter/material.dart';

class AttendanceCard extends StatelessWidget {
  final Map<String, dynamic> attendance;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AttendanceCard({
    Key? key,
    required this.attendance,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          attendance['name'],
          style: TextStyle(fontWeight: FontWeight.bold , color: Color(0xFF3E595F) , fontSize: 20),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('code :  ${attendance['remark']}'),
            Text('date :  ${attendance['date']}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Color(0xFF3E595F),
              ),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Color(0xFF3E595F),
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
