import 'package:flutter/material.dart';

void main() => runApp(const VestaApp());

class VestaApp extends StatelessWidget {
  const VestaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Vesta', style: TextStyle(fontSize: 32)),
        ),
      ),
    );
  }
}