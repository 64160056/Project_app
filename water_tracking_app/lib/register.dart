// register.dart
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  static const String nameRoute = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: const Center(
        child: Text('Register Page'),
      ),
    );
  }
}
