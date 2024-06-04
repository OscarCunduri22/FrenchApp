import 'package:flutter/material.dart';
import 'dart:math' as math;

enum ShapeType { circle, square, star, triangle }

class ShapeWidget extends StatelessWidget {
  final ShapeType shapeType;
  final Color color;
  final double size;

  const ShapeWidget({
    required this.shapeType,
    required this.color,
    this.size = 50.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: _buildShape(),
    );
  }

  Widget _buildShape() {
    switch (shapeType) {
      case ShapeType.circle:
        return _buildCircle();
      case ShapeType.square:
        return _buildSquare();
      case ShapeType.star:
        return _buildStar();
      case ShapeType.triangle:
        return _buildTriangle();
      default:
        return Container();
    }
  }

  Widget _buildCircle() {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildSquare() {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
      ),
    );
  }

  Widget _buildStar() {
    return CustomPaint(
      painter: StarPainter(color),
    );
  }

  Widget _buildTriangle() {
    return CustomPaint(
      painter: TrianglePainter(color),
    );
  }
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Path path = Path();

    double radiansPerStep = math.pi / 5;
    double halfRadiansPerStep = math.pi / 10;

    Offset center = Offset(radius, radius);

    for (int i = 0; i < 10; i++) {
      double radiusCurrent = (i.isEven) ? radius : radius / 2;
      double xOffset =
          radiusCurrent * math.cos(i * radiansPerStep + halfRadiansPerStep) +
              radius;
      double yOffset =
          radiusCurrent * math.sin(i * radiansPerStep + halfRadiansPerStep) +
              radius;
      Offset currentPoint = Offset(xOffset, yOffset);
      (i == 0)
          ? path.moveTo(currentPoint.dx, currentPoint.dy)
          : path.lineTo(currentPoint.dx, currentPoint.dy);
    }
    path.close();

    final Paint paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
