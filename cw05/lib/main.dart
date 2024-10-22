import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(FishAquariumApp());
}

class FishAquariumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FishAquarium(),
    );
  }
}

class FishAquarium extends StatefulWidget {
  @override
  _FishAquariumState createState() => _FishAquariumState();
}

class _FishAquariumState extends State<FishAquarium>
    with SingleTickerProviderStateMixin {
  final List<Widget> fishList = [];
  double fishSpeed = 1.0;
  Color selectedColor = Colors.blue;
  int fishCount = 0;
  Random random = Random();

  // Add fish button logic.
  void addFish() {
    // TODO ADD FISH BUTTON LOGIC
  }

  void saveSettings() {
    // TODO SAVE SETTING
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fish Aquarium'),
      ),
      body: Column(
        children: [
          // Aquarium container
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              border: Border.all(color: Colors.black),
            ),
            child: Stack(
              children: fishList,
            ),
          ),
          // Control panel
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Button to add a new fish
                ElevatedButton(
                  onPressed: addFish,
                  child: Text('Add Fish'),
                ),
                // Slider to adjust fish speed
                Row(
                  children: [
                    Text('Fish Speed:'),
                    Expanded(
                      child: Slider(
                        value: fishSpeed,
                        min: 0.5,
                        max: 5.0,
                        divisions: 9,
                        onChanged: (value) {
                          setState(() {
                            fishSpeed = value;
                          });
                        },
                      ),
                    ),
                    Text('${fishSpeed.toStringAsFixed(1)}x'),
                  ],
                ),
                // Color selector
                Row(
                  children: [
                    const Text('Fish Color:'),
                    SizedBox(width: 10),
                    DropdownButton<Color>(
                      value: selectedColor,
                      items: const [
                        DropdownMenuItem(
                          value: Colors.blue,
                          child: Text('Blue'),
                        ),
                        DropdownMenuItem(
                          value: Colors.red,
                          child: Text('Red'),
                        ),
                        DropdownMenuItem(
                          value: Colors.green,
                          child: Text('Green'),
                        ),
                        DropdownMenuItem(
                          value: Colors.yellow,
                          child: Text('Yellow'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedColor = value!;
                        });
                      },
                    ),
                  ],
                ),
                // Save Settings button
                ElevatedButton(
                  onPressed: saveSettings,
                  child: Text('Save Settings'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Fish extends StatelessWidget {
  final Color color;

  Fish({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
