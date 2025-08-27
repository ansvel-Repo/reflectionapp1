import 'package:ansvel/homeandregistratiodesign/util/appthemedata.dart';
import 'package:flutter/material.dart';


class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : AppThemeData.primary50,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            subtitle: Text('Update your profile information'),
            onTap: () {
              // Navigate to profile settings
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Security'),
            subtitle: Text('Change your password and PIN'),
            onTap: () {
              // Navigate to security settings
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Manage your notification preferences'),
            onTap: () {
              // Navigate to notification settings
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('Select your preferred language'),
            onTap: () {
              // Navigate to language settings
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            subtitle: Text('Learn more about the app'),
            onTap: () {
              // Navigate to about page
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Handle logout
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                // Handle logout logic
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
