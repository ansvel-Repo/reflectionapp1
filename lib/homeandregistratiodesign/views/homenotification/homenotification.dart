import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? lastFetchedDate = prefs.getString('lastFetchedDate');

      QuerySnapshot snapshot;
      if (lastFetchedDate == null) {
        // Fetch all notifications
        snapshot = await FirebaseFirestore.instance
            .collection('notification')
            .where('userId', isEqualTo: user.uid)
            .get();
      } else {
        // Fetch only new notifications
        snapshot = await FirebaseFirestore.instance
            .collection('notification')
            .where('userId', isEqualTo: user.uid)
            .where('date', isGreaterThan: lastFetchedDate)
            .get();
      }

      List<Map<String, dynamic>> newNotifications = snapshot.docs
          .map((doc) => {
                'subject': doc['subject'],
                'messageBody': doc['messageBody'],
                'date': doc['date'],
                'time': doc['time'],
              })
          .toList();

      if (newNotifications.isNotEmpty) {
        // Update last fetched date
        String latestDate = newNotifications
            .map((notif) => notif['date'])
            .reduce((a, b) => a.compareTo(b) > 0 ? a : b);
        await prefs.setString('lastFetchedDate', latestDate);

        // Store new notifications
        List<String> existingNotifications =
            prefs.getStringList('notifications') ?? [];
        existingNotifications
            .addAll(newNotifications.map((notif) => notif.toString()));
        await prefs.setStringList('notifications', existingNotifications);

        setState(() {
          _notifications.addAll(newNotifications);
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchHistoricData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('notification')
          .where('userId', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .limit(50) // Adjust the limit as needed
          .get();

      List<Map<String, dynamic>> historicNotifications = snapshot.docs
          .map((doc) => {
                'subject': doc['subject'],
                'messageBody': doc['messageBody'],
                'date': doc['date'],
                'time': doc['time'],
              })
          .toList();

      // Store historic notifications
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> existingNotifications =
          prefs.getStringList('notifications') ?? [];
      existingNotifications
          .addAll(historicNotifications.map((notif) => notif.toString()));
      await prefs.setStringList('notifications', existingNotifications);

      setState(() {
        _notifications.addAll(historicNotifications);
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text('Error: $_errorMessage'))
                : _notifications.isEmpty
                    ? Center(child: Text('No notifications available.'))
                    : ListView.builder(
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_notifications[index]['subject']),
                            subtitle: Text(
                                '${_notifications[index]['messageBody'].substring(0, 150)}...'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationDetailPage(
                                    subject: _notifications[index]['subject'],
                                    messageBody: _notifications[index]
                                        ['messageBody'],
                                    date: _notifications[index]['date'],
                                    time: _notifications[index]['time'],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchHistoricData,
        child: Icon(Icons.history),
      ),
    );
  }
}

class NotificationDetailPage extends StatelessWidget {
  final String subject;
  final String messageBody;
  final String date;
  final String time;

  const NotificationDetailPage({
    Key? key,
    required this.subject,
    required this.messageBody,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              messageBody,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
