import 'package:flutter/material.dart';
import 'package:flutter_application_8/Event/event_helper.dart';

class AddEventScreen extends StatefulWidget {
  final Map<String, dynamic>? eventToEdit;
  final Function refreshEventList;

  AddEventScreen({this.eventToEdit, required this.refreshEventList});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.eventToEdit != null) {
      _nameController.text = widget.eventToEdit!['name'];
      _dateController.text = widget.eventToEdit!['date'];
      _locationController.text = widget.eventToEdit!['location'];
      _descriptionController.text = widget.eventToEdit!['description'];
      _timeController.text = widget.eventToEdit!['time'];
    }
  }

  Future<void> _addEvent() async {
    final name = _nameController.text.trim();
    final date = _dateController.text.trim();
    final location = _locationController.text.trim();
    final description = _descriptionController.text.trim();
    final time = _timeController.text.trim();

    if (name.isNotEmpty && date.isNotEmpty && location.isNotEmpty && time.isNotEmpty) {
      final event = {
        'name': name,
        'date': date,
        'time': time,
        'location': location,
        'description': description,
        'status': 0,
      };

      try {
        if (widget.eventToEdit == null) {
          await DatabasesHelper.instance.addEvent(event);
        } else {
          await DatabasesHelper.instance.updateEvent(widget.eventToEdit!['id'], event);
        }

        widget.refreshEventList();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all the fields!'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventToEdit == null ? 'Add Event' : 'Edit Event'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.eventToEdit == null ? 'Add a new event' : 'Edit event details',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Event Name',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Event Date',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Event Time',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Event Location',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Event Description',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.text,
              maxLines: 4,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _addEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: Colors.white,
              ),
              child: Text(
                widget.eventToEdit == null ? 'Add Event' : 'Save Changes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
