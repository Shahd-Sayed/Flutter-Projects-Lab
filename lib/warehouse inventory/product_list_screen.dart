import 'package:flutter/material.dart';
import 'package:flutter_application_8/warehouse%20inventory/product.dart';
import 'package:flutter_application_8/warehouse%20inventory/product_tilte.dart';
import 'package:flutter_application_8/warehouse%20inventory/warehouseInventory_helpers.dart';

import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    final products = await DatabaseHelper.instance.getAllProducts();
    setState(() {
      _products = products;
    });
  }

  void _addOrEditProduct([Product? product]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    ).then((_) => _fetchProducts());  
  }

  void _deleteProduct(int id) async {
    await DatabaseHelper.instance.deleteProduct(id);
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Warehouse Inventory',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF3C626B),
        elevation: 4.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return ProductTile(
              product: product,
              onEdit: () => _addOrEditProduct(product),
              onDelete: () => _deleteProduct(product.id!),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditProduct(), 
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor:Color(0xFF3C626B),
        elevation: 6.0,
      ),
    );
  }
}
