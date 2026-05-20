import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double radius;
  final String url;

  const Avatar({super.key, required this.radius, required this.url});

  @override
  Widget build(BuildContext context) {
    return url.isNotEmpty
        ? CircleAvatar(
            radius: radius,
            backgroundImage: NetworkImage(url),
          )
        : CircleAvatar(
            radius: radius,
            backgroundColor: Colors.white,
            child: FlutterLogo(size: radius),
          );
  }
}