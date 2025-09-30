import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChartData {
  final Color color;
  final double value;

  ChartData({required this.color, required this.value});
}

class SpendingChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double strokeWidth;
  final double animationValue; 

  SpendingChartPainter({
    required this.data, 
    this.strokeWidth = 25.0,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;
    final totalValue = data.fold(0.0, (sum, item) => sum + item.value);

    final backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, backgroundPaint);

    if (totalValue <= 0) return;

    double startAngle = -math.pi / 2; 

    for (var item in data) {
      final sweepAngle = (item.value / totalValue) * 2 * math.pi * animationValue;
      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant SpendingChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.data != data;
  }
}