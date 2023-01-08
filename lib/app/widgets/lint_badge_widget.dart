import 'package:flutter/material.dart';

class BadgeLint extends StatelessWidget {
  const BadgeLint({
    Key? key,
    required this.set,
  }) : super(key: key);

  final String set;

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (set) {
      case "core":
        color = Colors.blue.shade700;
        break;
      case "recommended":
        color = Colors.blue.shade800;
        break;
      case "flutter":
        color = Colors.blue.shade900;
        break;
      case "has fix":
        color = Colors.lightGreen.shade500;
        break;
      default:
        color = Colors.blue;
    }

    return DefaultTextStyle(
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w300,
        fontSize: 11,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: set != 'has fix',
            child: Container(
              color: Colors.grey.shade700,
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 2,
              ),
              child: Text('style'),
            ),
          ),
          Container(
            color: color,
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            child: Text(set),
          ),
        ],
      ),
    );
  }
}
