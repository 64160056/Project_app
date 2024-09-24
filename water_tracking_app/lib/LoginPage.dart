// register.dart
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  static const String nameRoute = '/LoginPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const Center(
        child: Text('Login Page'),
      ),
    );
  }
}
