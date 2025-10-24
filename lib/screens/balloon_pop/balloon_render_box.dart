import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Custom RenderBox that implements elliptical hit testing
/// Only registers taps that fall within the balloon's visible oval shape
class BalloonRenderBox extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  BalloonRenderBox({
    required VoidCallback onTap,
  }) : _onTap = onTap;

  VoidCallback _onTap;
  
  set onTap(VoidCallback value) {
    if (_onTap != value) {
      _onTap = value;
    }
  }

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = child!.size;
    } else {
      size = constraints.smallest;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!size.contains(position)) {
      return false;
    }

    // Check if tap is within elliptical balloon shape
    if (_isInsideEllipse(position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }

    return false;
  }

  /// Check if a point is inside the balloon's elliptical shape
  /// The balloon occupies approximately 85% width and 75% height (from painter)
  bool _isInsideEllipse(Offset position) {
    // Balloon body dimensions (matching BalloonPainter)
    final centerX = size.width / 2;
    final bodyHeight = size.height * 0.75; // Balloon body is 75% of total height
    final centerY = bodyHeight / 2; // Center of the ellipse
    
    // Ellipse radii (85% of dimensions as per BalloonPainter)
    final radiusX = (size.width * 0.85) / 2;
    final radiusY = bodyHeight / 2;
    
    // Normalize tap position relative to ellipse center
    final normalizedX = (position.dx - centerX) / radiusX;
    final normalizedY = (position.dy - centerY) / radiusY;
    
    // Point is inside ellipse if: (x/a)² + (y/b)² <= 1
    final distanceSquared = normalizedX * normalizedX + normalizedY * normalizedY;
    
    return distanceSquared <= 1.0;
  }

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _onTap();
    }
  }
}

/// Widget that uses BalloonRenderBox for precise hit testing
class BalloonHitTestWidget extends SingleChildRenderObjectWidget {
  final VoidCallback onTap;

  const BalloonHitTestWidget({
    super.key,
    required this.onTap,
    required Widget child,
  }) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return BalloonRenderBox(onTap: onTap);
  }

  @override
  void updateRenderObject(BuildContext context, covariant BalloonRenderBox renderObject) {
    renderObject.onTap = onTap;
  }
}

