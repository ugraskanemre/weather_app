import 'package:flutter/cupertino.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0XFF90CAF9),
            Color(0XFF01579B),
          ],
        ),
      ),
    );
  }
}
