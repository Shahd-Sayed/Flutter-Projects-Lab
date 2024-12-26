import 'package:flutter/material.dart';
import 'package:flutter_application_8/Financial/S_add.dart';
import 'package:flutter_application_8/Financial/S_data.dart';


class SHomeScreen extends StatefulWidget {
  final double totalAmount;

  SHomeScreen({required this.totalAmount});

  @override
  _SHomeScreenState createState() => _SHomeScreenState();
}

class _SHomeScreenState extends State<SHomeScreen> {
  final dbHelper = SDatabaseHelper.instance;
  List<Expense> _expenses = [];
  double _remainingAmount = 0;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _remainingAmount = widget.totalAmount;
    _loadExpenses();
  }

  void _loadExpenses() async {
    final expenses = await dbHelper.fetchAllExpenses();
    setState(() {
      _expenses = expenses.map((e) => Expense.fromMap(e)).toList();
      _remainingAmount = widget.totalAmount - 
          _expenses.fold(0, (sum, item) => sum + item.amount);
    });
  }

  void _onAddExpense(String name, double amount) async {
    final expense = Expense(name: name, amount: amount);
    await dbHelper.insertExpense(expense);
    _loadExpenses();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      showSavedAmount();
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddExpenseScreen(onSave: _onAddExpense),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        ),
      );
    }
  }

  void showSavedAmount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Saved Amount'),
          content: Text(
              'Your remaining saved amount is: \$${_remainingAmount.toStringAsFixed(2)}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showExpenseDetails(Expense expense) {
    TextEditingController amountController = TextEditingController(text: expense.amount.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(expense.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Amount:'),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Enter new amount'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  double newAmount = double.tryParse(amountController.text) ?? expense.amount;
                  Expense updatedExpense = Expense(
                    id: expense.id,
                    name: expense.name,
                    amount: newAmount,
                  );
                  await dbHelper.updateExpense(updatedExpense);
                  Navigator.pop(context);
                  _loadExpenses(); 
                },
                child: Text('Save Changes'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF629e84),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF629e84),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remaining Amount',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${_remainingAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Expenses List:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF629e84)),
            ),
            Expanded(
              child: _expenses.isEmpty
                  ? Center(
                      child: Text(
                      'No expenses added yet.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF629e84),
                      ),
                    ))
                  : ListView.builder(
                      itemCount: _expenses.length,
                      itemBuilder: (context, index) {
                        final expense = _expenses[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(expense.name,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Amount: \$${expense.amount.toStringAsFixed(2)}'),
                            onTap: () {
                              _showExpenseDetails(expense);
                            },
                            trailing: IconButton(
                              icon:
                                  Icon(Icons.delete, color: Color(0xFF629e84)),
                              onPressed: () async {
                                await dbHelper.deleteExpense(expense.id!);
                                _loadExpenses();
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Saved Amount',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Expense',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        backgroundColor: Color(0xFF629e84), 
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF629e84),
      ),
      body: Center(
        child: Text(
          'This is the Profile screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
