import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double progress;
  final double strokeWidth;
  final double innerRadius;
  final Color progressColor;
  final Color backgroundColor;

  const CustomCircularProgressIndicator({
    super.key,
    required this.progress,
    this.strokeWidth = 8.0,
    this.innerRadius = 10.0,
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100, 100),
      painter: _CircularProgressPainter(
        progress: progress,
        strokeWidth: strokeWidth,
        innerRadius: innerRadius,
        progressColor: progressColor,
        backgroundColor: backgroundColor,
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final double innerRadius;
  final Color progressColor;
  final Color backgroundColor;

  _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.innerRadius,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw the background circle
    paint.color = backgroundColor;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2 - strokeWidth / 2, paint);

    // Draw the progress circle
    paint.color = progressColor;
    paint.strokeCap = StrokeCap.round;
    double sweepAngle = 2 * 3.141592653589793 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2 - strokeWidth / 2),
      -3.141592653589793 / 2, // Start angle (top)
      sweepAngle, // End angle
      false, // Not using the center
      paint,
    );

    // Draw inner circle (empty space in the middle)
    paint.color = backgroundColor;
    paint.strokeWidth = 0; // Set stroke width to 0 to fill the circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), innerRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}