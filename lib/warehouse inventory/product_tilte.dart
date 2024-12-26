import 'package:flutter/material.dart';
import 'package:flutter_application_8/warehouse%20inventory/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductTile({
    Key? key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          product.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF3C626B),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'Quantity: ${product.quantity}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Color(0xFF3C626B),
              ),
              onPressed: onEdit,
              splashColor: Colors.grey[400],
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Color(0xFF3C626B),
              ),
              onPressed: onDelete,
              splashColor: Colors.black.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
