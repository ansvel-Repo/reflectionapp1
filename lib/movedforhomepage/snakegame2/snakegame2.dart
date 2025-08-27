import 'dart:async';
import 'dart:math';

// import 'package:ansvel/custombottomnavigation/bottom_nav_with_animated_icons.dart';
import 'package:ansvel/homeandregistratiodesign/views/custombottomnavigation/bottom_nav_with_animated_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/dashboard.dart';

class SnakeGamePage extends StatefulWidget {
  const SnakeGamePage({super.key});

  @override
  State<SnakeGamePage> createState() => _SnakeGamePageState();
}

enum Direction { up, down, left, right }

class _SnakeGamePageState extends State<SnakeGamePage> {
  int row = 20, column = 20;
  List<int> borderList = [];
  List<int> snakePosition = [];
  int snakeHead = 0;
  int score = 11;
  late Direction direction;
  late int foodPoistion;

  @override
  void initState() {
    startGame();
    super.initState();
  }

  void startGame() {
    makeBorder();
    generateFood();
    direction = Direction.right;
    snakePosition = [45, 44, 43];
    snakeHead = snakePosition.first;
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      updateSnake();
      if (checkCollision()) {
        timer.cancel();
        showGameOverDialog();
      }
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: const Text("Your snake collided!"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  startGame();
                },
                child: const Text("Restart"))
          ],
        );
      },
    );
  }

  bool checkCollision() {
    //if snake collid with border
    if (borderList.contains(snakeHead)) return true;
    //if snake collid with itself
    if (snakePosition.sublist(1).contains(snakeHead)) return true;
    return false;
  }

  void generateFood() {
    foodPoistion = Random().nextInt(row * column);
    if (borderList.contains(foodPoistion)) {
      generateFood();
    }
  }

  void updateSnake() {
    setState(() {
      switch (direction) {
        case Direction.up:
          snakePosition.insert(0, snakeHead - column);
          break;
        case Direction.down:
          snakePosition.insert(0, snakeHead + column);
          break;
        case Direction.right:
          snakePosition.insert(0, snakeHead + 1);
          break;
        case Direction.left:
          snakePosition.insert(0, snakeHead - 1);
          break;
      }
    });

    if (snakeHead == foodPoistion) {
      score++;
      generateFood();
    } else {
      snakePosition.removeLast();
    }

    snakeHead = snakePosition.first;
  }

  double x = 20;
  double y = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [Expanded(child: _buildGameView()), _buildGameControls()],
          ),
          // Draggable Floating Button
          Positioned(
            left: x,
            top: y,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  x += details.delta.dx;
                  y += details.delta.dy;
                });
              },
              onTap: () {
                Get.to(() => const BottomNavWithAnimatedIcons());
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/logos/ansvellogoonly.png'), // Replace with your actual logo path
                    fit: BoxFit.fill,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGameView() {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: column),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: fillBoxColor(index)),
        );
      },
      itemCount: row * column,
    );
  }

  Widget _buildGameControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Score : $score"),
          IconButton(
            onPressed: () {
              if (direction != Direction.down) direction = Direction.up;
            },
            icon: const Icon(Icons.arrow_circle_up),
            iconSize: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (direction != Direction.right) direction = Direction.left;
                },
                icon: const Icon(Icons.arrow_circle_left_outlined),
                iconSize: 100,
              ),
              const SizedBox(width: 100),
              IconButton(
                onPressed: () {
                  if (direction != Direction.left) direction = Direction.right;
                },
                icon: const Icon(Icons.arrow_circle_right_outlined),
                iconSize: 100,
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              if (direction != Direction.up) direction = Direction.down;
            },
            icon: const Icon(Icons.arrow_circle_down_outlined),
            iconSize: 100,
          ),
        ],
      ),
    );
  }

  Color fillBoxColor(int index) {
    if (borderList.contains(index))
      return Colors.yellow;
    else {
      if (snakePosition.contains(index)) {
        if (snakeHead == index) {
          return Colors.green;
        } else {
          return Colors.white.withOpacity(0.9);
        }
      } else {
        if (index == foodPoistion) {
          return Colors.red;
        }
      }
    }
    return Colors.grey.withOpacity(0.05);
  }

  makeBorder() {
    for (int i = 0; i < column; i++) {
      if (!borderList.contains(i)) borderList.add(i);
    }
    for (int i = 0; i < row * column; i = i + column) {
      if (!borderList.contains(i)) borderList.add(i);
    }
    for (int i = column - 1; i < row * column; i = i + column) {
      if (!borderList.contains(i)) borderList.add(i);
    }
    for (int i = (row * column) - column; i < row * column; i = i + 1) {
      if (!borderList.contains(i)) borderList.add(i);
    }
  }
}
