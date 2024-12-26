import 'package:flutter/material.dart';
import 'package:flutter_application_8/Event/event_helper.dart';

class EditEventScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  const EditEventScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.event['name'];
    _dateController.text = widget.event['date'];
    _locationController.text = widget.event['location'];
    _descriptionController.text = widget.event['description'];
    _timeController.text = widget.event['time'];
  }

  Future<void> _updateEvent() async {
    final updatedEvent = {
      'name': _nameController.text,
      'date': _dateController.text,
      'time': _timeController.text,
      'location': _locationController.text,
      'description': _descriptionController.text,
      'status': widget.event['status'],
    };

    await DatabasesHelper.instance.updateEvent(widget.event['id'], updatedEvent);
    Navigator.pop(context, true);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final formattedTime = selectedTime.format(context);
      setState(() {
        _timeController.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Event Date'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Event Location'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Event Description'),
            ),
            TextField(
              controller: _timeController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Event Time'),
              onTap: () => _selectTime(context),
            ),
            ElevatedButton(
              onPressed: _updateEvent,
              child: Text('Update Event'),
            ),
          ],
        ),
      ),
    );
  }
}
