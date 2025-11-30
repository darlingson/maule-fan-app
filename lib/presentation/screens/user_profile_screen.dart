import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: const Color(0xFFDA1A32),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Basic User App Config',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

