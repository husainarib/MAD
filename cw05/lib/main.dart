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

class _FishAquariumState extends State<FishAquarium> {
  final List<Fish> fishList = [];
  double fishSpeed = 1.0;
  Color selectedColor = Colors.blue;
  Random random = Random();

  void _updateFishSpeed() {
    setState(() {
      for (var i = 0; i < fishList.length; i++) {
        fishList[i] = Fish(
          color: fishList[i].color,
          speed: fishSpeed,
        );
      }
    });
  }

  // Add Fish Method
  void _addFish() {
    if (fishList.length < 10) {
      setState(() {
        fishList.add(Fish(
          color: selectedColor,
          speed: fishSpeed,
        ));
      });
    }
  }

  // Remove Fish method
  void _removeFish() {
    if (fishList.isNotEmpty) {
      setState(() {
        fishList.removeLast();
      });
    }
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
          // Button and Slider
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Button to add a new fish
                ElevatedButton(
                  onPressed: _addFish,
                  child: Text('Add Fish'),
                ),
                const SizedBox(height: 10),
                // Button to remove the last fish
                ElevatedButton(
                  onPressed: _removeFish,
                  child: Text('Remove Fish'),
                ),
                // Slider for Spped
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
                            _updateFishSpeed();
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
  final double speed;

  Fish({required this.color, required this.speed});

  @override
  _FishState createState() => _FishState();
}

class _FishState extends State<Fish> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double xPosition = 0.0;
  double yPosition = 0.0;
  bool movingRight = true;
  bool movingDown = true;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    xPosition = random.nextDouble() * 250;
    yPosition = random.nextDouble() * 250;

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      setState(() {
        _moveFish();
      });
    });
  }

  void updateSpeed(double newSpeed) {
    _controller.duration = Duration(seconds: (5 / newSpeed).round());
    _controller.reset();
    _controller.repeat();
  }

  // Method to move fish
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
