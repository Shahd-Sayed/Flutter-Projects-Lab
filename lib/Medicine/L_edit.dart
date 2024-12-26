import 'package:flutter/material.dart';
import 'package:flutter_application_8/Medicine/L_data.dart';

class EditMedicinePage extends StatefulWidget {
  final Medicine medicine;
  final Function(Medicine) onUpdate;

  EditMedicinePage({required this.medicine, required this.onUpdate});

  @override
  _EditMedicinePageState createState() => _EditMedicinePageState();
}

class _EditMedicinePageState extends State<EditMedicinePage> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _timeController = TextEditingController();
  String _type = 'Tablet';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.medicine.name;
    _dosageController.text = widget.medicine.dosage;
    _timeController.text = widget.medicine.time;
    _type = widget.medicine.type;
  }

  _save() {
    final updatedMedicine = Medicine(
      id: widget.medicine.id,
      name: _nameController.text,
      dosage: _dosageController.text,
      type: _type,
      time: _timeController.text,
    );
    widget.onUpdate(updatedMedicine);
    Navigator.pop(context, updatedMedicine);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Medicine')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            ElevatedButton(onPressed: _save, child: Text('Save Changes')),
          ],
        ),
      ),
    );
  }
}
