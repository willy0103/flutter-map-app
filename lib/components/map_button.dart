import 'package:flutter/material.dart';
import 'package:modernlogintute/pages/chat.dart';

import '../pages/myhome.dart';

class MapButton1 extends StatelessWidget {
  final String imagePath;

  const MapButton1({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(53, 53),
        foregroundColor: const Color.fromARGB(0, 255, 255, 255),
        backgroundColor: Color.fromARGB(255, 233, 186, 219),
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Image.asset(
        imagePath,
        height: 30,
      ),
    );
  }
}

class MapButton2 extends StatelessWidget {
  final String imagePath;

  const MapButton2({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => personal()),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(53, 53),
        foregroundColor: const Color.fromARGB(0, 255, 255, 255),
        backgroundColor: Color.fromRGBO(162, 229, 238, 1),
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Image.asset(
        imagePath,
        height: 30,
      ),
    );
  }
}

class MapButton3 extends StatelessWidget {
  final String imagePath;

  const MapButton3({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => personal()),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(53, 53),
        foregroundColor: const Color.fromARGB(0, 255, 255, 255),
        backgroundColor: Color.fromARGB(255, 233, 186, 219),
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Image.asset(
        imagePath,
        height: 30,
      ),
    );
  }
}

class MapButton4 extends StatelessWidget {
  final String imagePath;
  final void Function() onPressed;

  const MapButton4({Key? key, required this.imagePath, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(40, 40),
        foregroundColor: const Color.fromARGB(0, 255, 255, 255),
        backgroundColor: Color.fromARGB(255, 233, 186, 219),
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Image.asset(
        imagePath,
        height: 20,
      ),
    );
  }
}
