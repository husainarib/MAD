import 'package:flutter/material.dart';

//detail screen class
class DetailScreen extends StatelessWidget {
  final String name;
  final String detail;

  DetailScreen({required this.name, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: const Color.fromARGB(255, 201, 227, 247),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 31, 104, 165),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Card(
                color: const Color.fromARGB(255, 225, 241, 255),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    detail,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
