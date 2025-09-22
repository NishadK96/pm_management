
import 'package:flutter/material.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://placeimg.com/640/480/any'),
            ),
            SizedBox(height: 16),
            Text('Full Name'),
            TextField(),
            SizedBox(height: 16),
            Text('Address'),
            TextField(),
            SizedBox(height: 16),
            Text('Contact Number'),
            TextField(),
            SizedBox(height: 16),
            Text('Email'),
            TextField(),
            SizedBox(height: 16),
            Text('Job Details'),
            TextField(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Save Details'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}