import 'package:flutter/material.dart';
import 'package:flutter_application_8/attendance/database_helper.dart';
import 'attendance_card.dart'; 

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  List<Map<String, dynamic>> _attendanceList = [];

  Future<void> _fetchAttendance() async {
    final attendance = await DatabaseHelper.instance.getAllAttendance();
    setState(() {
      _attendanceList = attendance;
    });
  }

  Future<void> _addAttendance() async {
    final name = _nameController.text.trim();
    final date = _dateController.text.trim();
    final remark = _remarkController.text.trim();

    if (name.isNotEmpty && date.isNotEmpty) {
      final attendance = {
        'name': name,
        'date': date,
        'remark': remark,
      };
      await DatabaseHelper.instance.addAttendance(attendance);
      _fetchAttendance();
      _nameController.clear();
      _dateController.clear();
      _remarkController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a name and date!')),
      );
    }
  }

  Future<void> _editAttendance(
      int id, String newName, String newDate, String newRemark) async {
    final updatedAttendance = {
      'id': id,
      'name': newName,
      'date': newDate,
      'remark': newRemark,
    };
    await DatabaseHelper.instance.updateAttendance(updatedAttendance);
    _fetchAttendance();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Attendance updated successfully!')),
    );
  }

  Future<void> _deleteAttendance(int id) async {
    await DatabaseHelper.instance.deleteAttendance(id);
    _fetchAttendance();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Attendance deleted successfully!')),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance App',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF3E595F),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'Add Attendance',
                      style: TextStyle(
                        color: Color(0xFF3E595F),
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration:
                                InputDecoration(labelText: 'Enter Name'),
                          ),
                          TextField(
                            controller: _dateController,
                            decoration:
                                InputDecoration(labelText: 'Enter Date'),
                          ),
                          TextField(
                            controller: _remarkController,
                            decoration:
                                InputDecoration(labelText: 'Enter Code'),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB4BCBC),
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          _addAttendance();
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text('Add'),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3E595F),
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text('Cancel'),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  'Add Attendance',
                  style: TextStyle(
                    color: Color(0xFF3E595F),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _attendanceList.length,
              itemBuilder: (context, index) {
                final attendance = _attendanceList[index];
                return AttendanceCard(
                  attendance: attendance,
                  onEdit: () {
                    TextEditingController _editNameController =
                        TextEditingController(text: attendance['name']);
                    TextEditingController _editDateController =
                        TextEditingController(text: attendance['date']);
                    TextEditingController _editRemarkController =
                        TextEditingController(text: attendance['remark']);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Edit Attendance',
                            style: TextStyle(
                              color: Color(0xFF3E595F),
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _editNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter New Name',
                                  ),
                                ),
                                TextField(
                                  controller: _editDateController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter New Date',
                                  ),
                                ),
                                TextField(
                                  controller: _editRemarkController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Your Code',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFB4BCBC),
                                foregroundColor: Colors.white,
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _editAttendance(
                                  attendance['id'],
                                  _editNameController.text.trim(),
                                  _editDateController.text.trim(),
                                  _editRemarkController.text.trim(),
                                );
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text('Save'),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3E595F),
                                foregroundColor: Colors.white,
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text('Cancel'),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDelete: () {
                    _deleteAttendance(attendance['id']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
