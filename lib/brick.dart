import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {
  final x;
  final y;
  final brickWidth; // outOf 2
  final thisIsEnemy;

  MyBrick({this.x, this.y, this.brickWidth, this.thisIsEnemy});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment((2*x + brickWidth) / (2-brickWidth), y),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: this.thisIsEnemy ? Colors.deepPurple.shade300 : Colors.pink.shade300,
            height: 20,
            width: MediaQuery.of(context).size.width * brickWidth / 2,
          ),
        )
    );
  }
}
