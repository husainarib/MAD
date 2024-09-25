//Arib Husain #002-62-2009
import 'package:flutter/material.dart';
import 'homeScreen.dart';

void main() {
  runApp(RecipeApp());
}

//recipe app main dart class
class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
