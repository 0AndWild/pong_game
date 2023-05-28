import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong_game/ball.dart';
import 'package:pong_game/brick.dart';
import 'package:pong_game/coverscreen.dart';
import 'package:pong_game/scorescreen.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<Homepage> {
  // player variables (bottom brick)
  double playerX = -0.2;
  double brickWidth = 0.4; // outOf 2
  int playerScore = 0;

  // enemy variables (top brick)
  double enemyX = -0.2;
  int enemyScore = 0;

  // ball variable
  double ballX = 0.0;
  double ballY = 0.0;
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;

  // game setting
  bool gameHasStarted = false;

  void startGame() {
    if (gameHasStarted == false) {
      gameHasStarted = true;
      Timer.periodic(Duration(milliseconds: 7), (timer) {
        // update direction
        updateDirection();

        // move ball
        moveBall();

        // move enemy
        moveEnemy();

        // check if plater is dead
        if (isPlayerDead()) {
          enemyScore ++;
          timer.cancel();
          _showDialog(false);
        }

        if (isEnemyDead()) {
          playerScore ++;
          timer.cancel();
          _showDialog(true);
        }
      });
    }
  }

  bool isEnemyDead() {
    if (ballY <= -1) {
      return true;
    }
    return false;
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  void moveEnemy() {
    setState(() {
      enemyX = ballX;
    });
  }

  void _showDialog(bool enemyDied) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(
                enemyDied ? "PINK WIN" :"PURPLE WIN",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: enemyDied ? Colors.pink.shade100 : Colors.deepPurple.shade100,
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: enemyDied ? Colors.pink.shade800 : Colors.deepPurple.shade800),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      gameHasStarted = false;
      ballX = 0;
      ballY = 0;
      playerX = -0.2;
      enemyX = -0.2;
    });
  }

  void updateDirection() {
    setState(() {
      // update vertical direction
      if (ballY >= 0.9 && playerX + brickWidth >= ballX && playerX <= ballX) {
        ballYDirection = direction.UP;
      } else if (ballY <= -0.85) {
        ballYDirection = direction.DOWN;
      }

      // update horizontal direction
      if (ballX >= 1.0) {
        ballXDirection = direction.LEFT;
      } else if (ballX <= -1.0) {
        ballXDirection = direction.RIGHT;
      }
    });
  }

  void moveBall() {
    setState(() {
      // vertical movement
      if (ballYDirection == direction.DOWN) {
        ballY += 0.01;
      } else if (ballYDirection == direction.UP) {
        ballY -= 0.01;
      }

      // horizontal movement
      if (ballXDirection == direction.LEFT) {
        ballX -= 0.01;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += 0.01;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (!(playerX - 0.1 <= -1)) {
        playerX -= 0.1;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!(playerX + brickWidth >= 1)) {
        playerX += 0.1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
          onTap: startGame,
          child: Scaffold(
              backgroundColor: Colors.grey.shade900,
              body: Center(
                child: Stack(
                  children: [
                    //tap to play
                    CoverScreen(
                      gameHasStarted: gameHasStarted,
                    ),

                    //scoreScreen
                    ScoreScreen(
                      gameHasStarted: gameHasStarted,
                      enemyScore: enemyScore,
                      playerScore: playerScore,
                    ),

                    // top brick
                    MyBrick(
                      x: enemyX,
                      y: -0.85,
                      brickWidth: brickWidth,
                      thisIsEnemy: true,
                    ),

                    // bottom brick
                    MyBrick(
                      x: playerX,
                      y: 0.9,
                      brickWidth: brickWidth,
                      thisIsEnemy: false,
                    ),

                    //ball
                    MyBall(x: ballX, y: ballY, gameHasStarted: gameHasStarted,),
                  ],
                ),
              ))),
    );
  }
}
