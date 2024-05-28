import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import a loading spinner package

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(context, '/loading-screen', (route) => false);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logging out...'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: SpinKitCircle(
          color: Colors.blue,
          size: 50.0,
        ),
      ),
    );
  }
}
