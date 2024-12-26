import 'package:flutter/material.dart';
import 'package:flutter_application_8/Event/AddEventScreen.dart';
import 'package:flutter_application_8/Event/event_helper.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _events = [];

  Future<void> _fetchEvents() async {
    final events = await DatabasesHelper.instance.getAllEvents();
    setState(() {
      _events = events;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _refreshEventList() {
    _fetchEvents();
  }

  void _deleteEvent(int id) async {
    await DatabasesHelper.instance.deleteEvent(id);
    _fetchEvents();
  }

  void _openEditScreen(Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventScreen(
          refreshEventList: _refreshEventList,
          eventToEdit: event,
        ),
      ),
    );
  }

  Widget _buildEventListScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
        backgroundColor: Colors.teal,
      ),
      body: _events.isEmpty
          ? Center(
              child: Text(
                'No events available. Add new events to get started!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12.0),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.teal[100],
                      child: Text(
                        event['name'][0],
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.teal[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      event['name'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      event['date'],
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.teal),
                          onPressed: () => _deleteEvent(event['id']),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.teal),
                          onPressed: () => _openEditScreen(event),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildProfileScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0 ? _buildEventListScreen() : _buildProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEventScreen(
                  refreshEventList: _refreshEventList,
                ),
              ),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.teal[200],
      ),
    );
  }
}
