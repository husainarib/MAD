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

  void _addFish() {
    if (fishList.length < 10) {
      setState(() {
        fishList.add(Fish(color: selectedColor));
      });
    }
  }

  void _removeFish() {
    if (fishList.isNotEmpty) {
      setState(() {
        fishList.removeLast();
      });
    }
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
                  onPressed: _addFish,
                  child: Text('Add Fish'),
                ),
                const SizedBox(width: 10),
                // Button to remove the last fish
                ElevatedButton(
                  onPressed: _removeFish,
                  child: Text('Remove Fish'),
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

class Fish extends StatefulWidget {
  final Color color;
  Fish({required this.color});

  @override
  _FishState createState() => _FishState();
}

class _FishState extends State<Fish> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;
  double xPosition = 0.0;
  double yPosition = 0.0;
  bool movingRight = true;
  bool movingDown = true;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    // Random starting position
    xPosition = random.nextDouble() * 250;
    yPosition = random.nextDouble() * 250;

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _xAnimation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _moveFish();
        });
      });
  }

  void _moveFish() {
    // Move horizontally
    if (movingRight) {
      xPosition += random.nextDouble() * 2;
      if (xPosition >= 270) {
        movingRight = false;
      }
    } else {
      xPosition -= random.nextDouble() * 2;
      if (xPosition <= 0) {
        movingRight = true;
      }
    }

    // Move vertically
    if (movingDown) {
      yPosition += random.nextDouble() * 2;
      if (yPosition >= 270) {
        movingDown = false;
      }
    } else {
      yPosition -= random.nextDouble() * 2;
      if (yPosition <= 0) {
        movingDown = true;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: xPosition,
      top: yPosition,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
        ),
      ),
    );
  }
}
