import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EMA Shop',
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const Scaffold(
        body: Center(
          child: Text(
            'EMA Shop',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
