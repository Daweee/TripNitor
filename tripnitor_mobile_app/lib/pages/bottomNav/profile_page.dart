import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text('Profile'),
          ),
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            CircleAvatar(),
            Text('Settings'),
            Text('Billing Details'),
            SizedBox(
              height: 90,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(), // subject to change
                    ),
                  );
                },
                child: Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}
