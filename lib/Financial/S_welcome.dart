import 'package:flutter/material.dart';
import 'package:flutter_application_8/Financial/S_homescreen.dart';

class SWelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<SWelcomeScreen> {
  final _totalAmountController = TextEditingController();

  void _goToHomeScreen() {
    final totalAmount = double.tryParse(_totalAmountController.text) ?? 0;
    if (totalAmount > 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SHomeScreen(totalAmount: totalAmount),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF629e84),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Image.asset(
              "assets/Wallet-bro (1).png",
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to the Expense Tracker',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _totalAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter total amount',
                labelStyle: TextStyle(color: Color(0xFF629e84)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _goToHomeScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 87, 141, 118),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(300, 40),
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
