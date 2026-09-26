import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(
    home: CellularCollapseScreen(),
    debugShowCheckedModeBanner: false,
  ),
);

class CellularCollapseScreen extends StatefulWidget {
  const CellularCollapseScreen({super.key});

  @override
  State<CellularCollapseScreen> createState() => _CellularCollapseScreenState();
}

class _CellularCollapseScreenState extends State<CellularCollapseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<CellularGrid> _grids = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..addListener(() {
            for (var grid in _grids) {
              grid.update(_controller.value);
            }
            setState(() {});
          });

    _initializeGrids();
    _controller.forward();
  }

  void _initializeGrids() {
    // Generates a 3x5 grid matching the visual layout
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 5; col++) {
        _grids.add(CellularGrid(row: row, col: col, color: _getRandomColor()));
      }
    }
  }

  Color _getRandomColor() {
    List<Color> baseColors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.yellow,
      Colors.cyan,
      Colors.lightGreenAccent,
    ];
    return baseColors[_random.nextInt(baseColors.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            itemCount: 15,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.black,
                child: CustomPaint(
                  painter: CellularPainter(grid: _grids[index]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Node {
  Offset basePosition;
  Offset currentPosition;
  final List<int> connections = [];

  Node(this.basePosition) : currentPosition = basePosition;
}

class CellularGrid {
  final int row;
  final int col;
  final Color color;
  final List<Node> nodes = [];
  final Random _rand = Random();

  CellularGrid({required this.row, required this.col, required this.color}) {
    _generateWeb();
  }

  void _generateWeb() {
    // Create dense, localized clusters of nodes
    int nodeCount = 35 + _rand.nextInt(20);
    for (int i = 0; i < nodeCount; i++) {
      nodes.add(
        Node(
          Offset(
            0.1 + _rand.nextDouble() * 0.8,
            0.1 + _rand.nextDouble() * 0.8,
          ),
        ),
      );
    }

    // Connect close neighbors to build organic, fibrous tissue structures
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        double dist = (nodes[i].basePosition - nodes[j].basePosition).distance;
        if (dist < 0.22) {
          nodes[i].connections.add(j);
        }
      }
    }
  }

  void update(double progress) {
    // Center of structural collapse
    Offset center = const Offset(0.5, 0.5);

    for (var node in nodes) {
      Offset direction = center - node.basePosition;

      // Dynamic calculation for structural deformation and fragmentation
      double collapseFactor = pow(progress, 2.5).toDouble();
      double individualDelay = (_rand.nextDouble() * 0.15);
      double effectiveProgress = (progress - individualDelay).clamp(0.0, 1.0);

      // Pull nodes inward toward the structural nucleus
      node.currentPosition = Offset.lerp(
        node.basePosition,
        center,
        effectiveProgress * collapseFactor,
      )!;
    }
  }
}

class CellularPainter extends CustomPainter {
  final CellularGrid grid;
  CellularPainter({required this.grid});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = grid.color.withOpacity(0.6)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final Paint nodePaint = Paint()
      ..color = grid.color
      ..style = PaintingStyle.fill;

    // Draw structural filaments
    for (var node in grid.nodes) {
      Offset p1 = Offset(
        node.currentPosition.dx * size.width,
        node.currentPosition.dy * size.height,
      );

      for (int targetIndex in node.connections) {
        var targetNode = grid.nodes[targetIndex];
        Offset p2 = Offset(
          targetNode.currentPosition.dx * size.width,
          targetNode.currentPosition.dy * size.height,
        );

        // Sever web connections as cells fragment during severe degradation
        if ((p1 - p2).distance > size.width * 0.02) {
          canvas.drawLine(p1, p2, linePaint);
        }
      }
    }

    // Draw localized cellular nuclei
    for (var node in grid.nodes) {
      Offset pos = Offset(
        node.currentPosition.dx * size.width,
        node.currentPosition.dy * size.height,
      );
      canvas.drawCircle(pos, 1.5, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CellularPainter oldDelegate) => true;
}
