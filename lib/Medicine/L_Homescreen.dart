import 'package:flutter/material.dart';
import 'package:flutter_application_8/Medicine/L_Sqlite.dart';
import 'package:flutter_application_8/Medicine/L_data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Medicine> _medicines = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  _loadMedicines() async {
    List<Medicine> medicines = await _dbHelper.getMedicines();
    setState(() {
      _medicines = medicines;
    });
  }

  _addMedicine() {
    showDialog(
      context: context,
      builder: (context) {
        return AddMedicineDialog(onSave: _onSaveMedicine);
      },
    );
  }

  _onSaveMedicine(Medicine medicine) async {
    await _dbHelper.insertMedicine(medicine);
    _loadMedicines();
    Navigator.pop(context);
  }

  _onUpdateMedicine(Medicine medicine) async {
    await _dbHelper.updateMedicine(medicine);
    _loadMedicines();
  }

  _deleteMedicine(int id) async {
    await _dbHelper.deleteMedicine(id);
    _loadMedicines();
  }

  _viewProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Medical Reminder'),
        backgroundColor: Color(0xFF6883C8),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _medicines.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicineDetailPage(
                        medicine: _medicines[index],
                        onUpdate: _onUpdateMedicine,
                        onDelete: () => _deleteMedicine(_medicines[index].id!),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _medicines[index].name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                          'Dosage: ${_medicines[index].dosage} - Time: ${_medicines[index].time}'),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            _addMedicine();
          } else if (index == 1) {
            _viewProfile();
          }
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Medicine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Color(0xFF6883C8),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class AddMedicineDialog extends StatefulWidget {
  final Function(Medicine) onSave;

  AddMedicineDialog({required this.onSave});

  @override
  _AddMedicineDialogState createState() => _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<AddMedicineDialog> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _timeController = TextEditingController();
  String _type = 'Tablet';

  _save() {
    final medicine = Medicine(
      name: _nameController.text,
      dosage: _dosageController.text,
      type: _type,
      time: _timeController.text,
    );
    widget.onSave(medicine);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Text('Add Medicine',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Medicine Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _dosageController,
              decoration: InputDecoration(
                labelText: 'Dosage',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Time',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _type,
              items: ['Tablet', 'Syrup', 'Injection'].map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Color(0xFF6883C8))),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text('Save'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6883C8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class MedicineDetailPage extends StatelessWidget {
  final Medicine medicine;
  final Function(Medicine) onUpdate;
  final Function onDelete;

  MedicineDetailPage(
      {required this.medicine, required this.onUpdate, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController(text: medicine.name);
    final _dosageController = TextEditingController(text: medicine.dosage);
    final _timeController = TextEditingController(text: medicine.time);

    _updateMedicine() {
      final updatedMedicine = Medicine(
        id: medicine.id,
        name: _nameController.text,
        dosage: _dosageController.text,
        time: _timeController.text,
        type: medicine.type,
      );
      onUpdate(updatedMedicine);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Details'),
        backgroundColor: Color(0xFF6883C8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Medicine Name'),
            ),
            TextField(
              controller: _dosageController,
              decoration: InputDecoration(labelText: 'Dosage'),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Time'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _updateMedicine,
                  child: Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () {
                    onDelete();
                    Navigator.pop(context);
                  },
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6883C8)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF6883C8),
      ),
      body: Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
