import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;

  const ProfileAvatar({Key? key, this.size = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey[300],
      child: Icon(Icons.person, size: size * 0.6, color: Colors.black87),
    );
  }
}
