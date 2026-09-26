import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

void main() {
  runApp(const OpticalLab3DApp());
}

class OpticalLab3DApp extends StatelessWidget {
  const OpticalLab3DApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Optical Laboratory 3D',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07111F),
        useMaterial3: true,
      ),
      home: const OpticalLabPage(),
    );
  }
}

class OpticalLabPage extends StatefulWidget {
  const OpticalLabPage({super.key});

  @override
  State<OpticalLabPage> createState() => _OpticalLabPageState();
}

class _OpticalLabPageState extends State<OpticalLabPage> {
  final Scene scene = Scene();

  late final PerspectiveCamera camera;

  bool ready = false;

  double azimuth = -0.65;
  double elevation = 0.48;
  double distance = 15.0;

  double startAzimuth = 0;
  double startElevation = 0;
  double startDistance = 0;

  String selectedComponent = 'Ti:Sapphire Laser';

  @override
  void initState() {
    super.initState();

    camera = PerspectiveCamera(
      position: vm.Vector3(8.5, 7.0, 10.0),
      target: vm.Vector3(0, 1.0, 0),
      fovRadiansY: 0.65,
      fovNear: 0.1,
      fovFar: 200,
    );

    _initializeScene();
  }

  Future<void> _initializeScene() async {
    await Scene.initializeStaticResources();

    _buildOpticalLaboratory();

    if (mounted) {
      setState(() {
        ready = true;
      });
    }
  }

  // ------------------------------------------------------------
  // MATERIALS
  // ------------------------------------------------------------

  PhysicallyBasedMaterial material(
    Color color, {
    double metallic = 0.0,
    double roughness = 0.45,
  }) {
    final m = PhysicallyBasedMaterial();

    m.baseColorFactor = vm.Vector4(
      color.red / 255.0,
      color.green / 255.0,
      color.blue / 255.0,
      color.opacity,
    );

    m.metallicFactor = metallic;
    m.roughnessFactor = roughness;

    return m;
  }

  UnlitMaterial glowingMaterial(Color color) {
    final m = UnlitMaterial();

    m.baseColorFactor = vm.Vector4(
      color.red / 255.0,
      color.green / 255.0,
      color.blue / 255.0,
      color.opacity,
    );

    return m;
  }

  // ------------------------------------------------------------
  // BASIC NODE HELPERS
  // ------------------------------------------------------------
  Node box(
    String name,
    vm.Vector3 size,
    vm.Vector3 position,
    Color color, {
    vm.Quaternion? rotation,
    double metallic = 0.0,
    double roughness = 0.45,
  }) {
    final Node node = Node(
      name: name,
      mesh: Mesh(
        CuboidGeometry(size),
        material(color, metallic: metallic, roughness: roughness),
      ),
    );

    node.position = position;

    if (rotation != null) {
      node.rotation = rotation;
    }

    return node;
  }

  Node sphere(
    String name,
    double radius,
    vm.Vector3 position,
    Color color, {
    vm.Vector3? scale,
    double metallic = 0.0,
    double roughness = 0.30,
  }) {
    final Node node = Node(
      name: name,
      mesh: Mesh(
        SphereGeometry(radius: radius, segments: 32, rings: 16),
        material(color, metallic: metallic, roughness: roughness),
      ),
    );

    node.position = position;

    if (scale != null) {
      node.scale = scale;
    }

    return node;
  }
  // ------------------------------------------------------------
  // OPTICAL LABORATORY
  // ------------------------------------------------------------

  void _buildOpticalLaboratory() {
    scene.add(_buildFloor());
    scene.add(_buildOpticalTable());

    scene.add(_buildLaser());
    scene.add(_buildMirror1());
    scene.add(_buildMirror2());
    scene.add(_buildBeamSplitter());

    scene.add(_buildCollimator());

    scene.add(_buildPlanoConvexLens());

    scene.add(_buildCloudChamber());

    scene.add(_buildSfpTransmitter());
    scene.add(_buildSfpReceiver());

    scene.add(_buildCamera());

    scene.add(_buildDetector());

    scene.add(_buildLaserBeamMain());
    scene.add(_buildLaserBeamToChamber());
    scene.add(_buildLaserBeamToDetector());

    scene.add(_buildOpticalRails());

    scene.add(_buildPowerSupply());

    scene.add(_buildCables());
  }

  // ------------------------------------------------------------
  // FLOOR
  // ------------------------------------------------------------

  Node _buildFloor() {
    return box(
      'Laboratory Floor',
      vm.Vector3(30, 0.25, 24),
      vm.Vector3(0, -0.5, 0),
      const Color(0xFF111A26),
      roughness: 0.8,
    );
  }

  // ------------------------------------------------------------
  // OPTICAL TABLE
  // ------------------------------------------------------------

  Node _buildOpticalTable() {
    final table = Node(name: 'Optical Table');

    table.add(
      box(
        'Table Top',
        vm.Vector3(18, 0.45, 9),
        vm.Vector3(0, 0, 0),
        const Color(0xFF242C35),
        metallic: 0.8,
        roughness: 0.25,
      ),
    );

    const legX = 7.5;
    const legZ = 3.5;

    for (final p in <vm.Vector3>[
      vm.Vector3(-legX, -2.1, -legZ),
      vm.Vector3(legX, -2.1, -legZ),
      vm.Vector3(-legX, -2.1, legZ),
      vm.Vector3(legX, -2.1, legZ),
    ]) {
      table.add(
        box(
          'Table Leg',
          vm.Vector3(0.65, 4.0, 0.65),
          p,
          const Color(0xFF333B45),
          metallic: 0.9,
          roughness: 0.25,
        ),
      );
    }

    return table;
  }

  // ------------------------------------------------------------
  // LASER
  // ------------------------------------------------------------

  Node _buildLaser() {
    final laser = Node(name: 'Ti:Sapphire Laser');

    laser.add(
      box(
        'Laser Body',
        vm.Vector3(3.0, 0.75, 1.25),
        vm.Vector3(-6.0, 1.0, -2.2),
        const Color(0xFF9B1C25),
        metallic: 0.55,
        roughness: 0.25,
      ),
    );

    laser.add(
      box(
        'Laser Top',
        vm.Vector3(2.4, 0.25, 0.9),
        vm.Vector3(-6.0, 1.48, -2.2),
        const Color(0xFFB7BBC0),
        metallic: 0.8,
        roughness: 0.2,
      ),
    );

    laser.add(
      sphere(
        'Laser Output',
        0.22,
        vm.Vector3(-4.45, 1.0, -2.2),
        const Color(0xFF5C6670),
        metallic: 0.9,
      ),
    );

    laser.add(
      sphere(
        'Laser Indicator',
        0.09,
        vm.Vector3(-5.0, 1.45, -2.2),
        const Color(0xFFFF3030),
        metallic: 0,
        roughness: 0.2,
      ),
    );

    return laser;
  }

  // ------------------------------------------------------------
  // MIRROR 1
  // ------------------------------------------------------------

  Node _buildMirror1() {
    final mirror = Node(name: 'Reflector Mirror 1');

    mirror.add(
      box(
        'Mirror Stand',
        vm.Vector3(0.35, 1.4, 0.35),
        vm.Vector3(-2.8, 0.9, -2.2),
        const Color(0xFF4A525C),
        metallic: 0.85,
        roughness: 0.2,
      ),
    );

    mirror.add(
      sphere(
        'Mirror Base',
        0.42,
        vm.Vector3(-2.8, 0.25, -2.2),
        const Color(0xFF353B42),
        metallic: 0.9,
        roughness: 0.2,
      ),
    );

    mirror.add(
      box(
        'Reflecting Surface',
        vm.Vector3(0.12, 1.8, 1.6),
        vm.Vector3(-2.8, 1.8, -2.2),
        const Color(0xFFB8D0DD),
        metallic: 1.0,
        roughness: 0.08,
        rotation: vm.Quaternion.axisAngle(vm.Vector3(0, 1, 0), math.pi / 4),
      ),
    );

    return mirror;
  }

  // ------------------------------------------------------------
  // MIRROR 2
  // ------------------------------------------------------------

  Node _buildMirror2() {
    final mirror = Node(name: 'Reflector Mirror 2');

    mirror.add(
      box(
        'Mirror Stand',
        vm.Vector3(0.35, 1.4, 0.35),
        vm.Vector3(4.0, 0.9, 1.2),
        const Color(0xFF4A525C),
        metallic: 0.85,
      ),
    );

    mirror.add(
      sphere(
        'Mirror Base',
        0.42,
        vm.Vector3(4.0, 0.25, 1.2),
        const Color(0xFF353B42),
        metallic: 0.9,
      ),
    );

    mirror.add(
      box(
        'Reflecting Surface',
        vm.Vector3(0.12, 1.8, 1.6),
        vm.Vector3(4.0, 1.8, 1.2),
        const Color(0xFFB8D0DD),
        metallic: 1.0,
        roughness: 0.08,
        rotation: vm.Quaternion.axisAngle(vm.Vector3(0, 1, 0), -math.pi / 4),
      ),
    );

    return mirror;
  }

  // ------------------------------------------------------------
  // BEAM SPLITTER
  // ------------------------------------------------------------

  Node _buildBeamSplitter() {
    final splitter = Node(name: 'Beam Splitter');

    splitter.add(
      box(
        'Splitter Mount',
        vm.Vector3(0.35, 1.2, 0.35),
        vm.Vector3(-0.5, 0.9, -0.3),
        const Color(0xFF4A525C),
        metallic: 0.85,
      ),
    );

    final glass = box(
      'Beam Splitter Glass',
      vm.Vector3(0.08, 1.6, 1.5),
      vm.Vector3(-0.5, 1.8, -0.3),
      const Color(0xFF79D6E8),
      roughness: 0.05,
      rotation: vm.Quaternion.axisAngle(vm.Vector3(0, 1, 0), math.pi / 4),
    );

    splitter.add(glass);

    return splitter;
  }

  // ------------------------------------------------------------
  // COLLIMATOR
  // ------------------------------------------------------------

  Node _buildCollimator() {
    final c = Node(name: 'Collimator');

    c.add(
      box(
        'Collimator Body',
        vm.Vector3(1.4, 0.65, 0.65),
        vm.Vector3(1.0, 1.0, -0.3),
        const Color(0xFF707982),
        metallic: 0.75,
        roughness: 0.25,
      ),
    );

    c.add(
      sphere(
        'Collimator Lens',
        0.35,
        vm.Vector3(1.72, 1.0, -0.3),
        const Color(0xFF76D8F5),
        scale: vm.Vector3(0.25, 1.0, 1.0),
        roughness: 0.05,
      ),
    );

    return c;
  }

  // ------------------------------------------------------------
  // PLANO CONVEX LENS
  // ------------------------------------------------------------

  Node _buildPlanoConvexLens() {
    final lens = Node(name: 'Plano Convex Lens');

    lens.add(
      box(
        'Lens Holder',
        vm.Vector3(0.35, 1.8, 1.8),
        vm.Vector3(2.4, 1.2, -0.3),
        const Color(0xFF444B54),
        metallic: 0.8,
        roughness: 0.2,
      ),
    );

    lens.add(
      sphere(
        'Plano Convex Lens',
        1.0,
        vm.Vector3(2.45, 1.2, -0.3),
        const Color(0xFF75CFE6),
        scale: vm.Vector3(0.28, 1.0, 1.0),
        roughness: 0.04,
      ),
    );

    return lens;
  }

  // ------------------------------------------------------------
  // CLOUD CHAMBER
  // ------------------------------------------------------------

  Node _buildCloudChamber() {
    final chamber = Node(name: 'Cloud Chamber');

    chamber.add(
      box(
        'Chamber Base',
        vm.Vector3(3.8, 0.5, 3.0),
        vm.Vector3(4.6, 0.45, -0.3),
        const Color(0xFF20262E),
        metallic: 0.6,
        roughness: 0.3,
      ),
    );

    chamber.add(
      box(
        'Chamber Body',
        vm.Vector3(3.4, 2.1, 2.6),
        vm.Vector3(4.6, 1.7, -0.3),
        const Color(0xFF6D7C88),
        metallic: 0.15,
        roughness: 0.35,
      ),
    );

    chamber.add(
      box(
        'Transparent Chamber',
        vm.Vector3(3.1, 1.7, 2.3),
        vm.Vector3(4.6, 1.75, -0.3),
        const Color(0xFF9EDBE6),
        metallic: 0.0,
        roughness: 0.08,
      ),
    );

    chamber.add(
      sphere(
        'Cloud Chamber Sensor',
        0.18,
        vm.Vector3(4.6, 2.8, -0.3),
        const Color(0xFFFFB000),
        roughness: 0.2,
      ),
    );

    return chamber;
  }

  // ------------------------------------------------------------
  // SFP TRANSMITTER
  // ------------------------------------------------------------

  Node _buildSfpTransmitter() {
    final sfp = Node(name: 'SFP Module TX');

    sfp.add(
      box(
        'TX Housing',
        vm.Vector3(1.8, 0.75, 1.2),
        vm.Vector3(7.1, 1.0, -0.3),
        const Color(0xFF22272E),
        metallic: 0.75,
        roughness: 0.25,
      ),
    );

    sfp.add(
      box(
        'TX Face',
        vm.Vector3(0.15, 0.55, 0.65),
        vm.Vector3(8.0, 1.0, -0.3),
        const Color(0xFF737C86),
        metallic: 0.8,
      ),
    );

    return sfp;
  }

  // ------------------------------------------------------------
  // SFP RECEIVER
  // ------------------------------------------------------------

  Node _buildSfpReceiver() {
    final sfp = Node(name: 'SFP Module RX');

    sfp.add(
      box(
        'RX Housing',
        vm.Vector3(1.8, 0.75, 1.2),
        vm.Vector3(5.5, 1.0, 3.0),
        const Color(0xFF22272E),
        metallic: 0.75,
        roughness: 0.25,
      ),
    );

    sfp.add(
      box(
        'RX Face',
        vm.Vector3(0.15, 0.55, 0.65),
        vm.Vector3(6.4, 1.0, 3.0),
        const Color(0xFF737C86),
        metallic: 0.8,
      ),
    );

    return sfp;
  }

  // ------------------------------------------------------------
  // CAMERA
  // ------------------------------------------------------------

  Node _buildCamera() {
    final camera = Node(name: 'Scientific Camera');

    camera.add(
      box(
        'Camera Body',
        vm.Vector3(1.6, 1.4, 1.5),
        vm.Vector3(8.0, 1.7, 3.0),
        const Color(0xFF181D23),
        metallic: 0.45,
        roughness: 0.3,
      ),
    );

    camera.add(
      sphere(
        'Camera Lens',
        0.65,
        vm.Vector3(7.1, 1.7, 3.0),
        const Color(0xFF273E54),
        scale: vm.Vector3(0.45, 1.0, 1.0),
        metallic: 0.35,
        roughness: 0.1,
      ),
    );

    return camera;
  }

  // ------------------------------------------------------------
  // DETECTOR
  // ------------------------------------------------------------

  Node _buildDetector() {
    final detector = Node(name: 'Detector');

    detector.add(
      box(
        'Detector Housing',
        vm.Vector3(1.3, 1.0, 1.3),
        vm.Vector3(5.5, 1.2, 4.3),
        const Color(0xFF3D454E),
        metallic: 0.65,
        roughness: 0.25,
      ),
    );

    detector.add(
      sphere(
        'Detector Sensor',
        0.35,
        vm.Vector3(4.85, 1.2, 4.3),
        const Color(0xFF62D6FF),
        scale: vm.Vector3(0.25, 1.0, 1.0),
        roughness: 0.05,
      ),
    );

    return detector;
  }

  // ------------------------------------------------------------
  // MAIN LASER BEAM
  // ------------------------------------------------------------

  Node _buildLaserBeamMain() {
    return box(
      'Laser Beam 1',
      vm.Vector3(8.0, 0.055, 0.055),
      vm.Vector3(-1.0, 1.0, -2.2),
      const Color(0xFFFF3030),
      roughness: 0.1,
    );
  }

  // ------------------------------------------------------------
  // BEAM TO CLOUD CHAMBER
  // ------------------------------------------------------------

  Node _buildLaserBeamToChamber() {
    final beam = box(
      'Laser Beam 2',
      vm.Vector3(5.0, 0.045, 0.045),
      vm.Vector3(4.0, 1.8, -0.3),
      const Color(0xFFFF3030),
      roughness: 0.1,
      rotation: vm.Quaternion.axisAngle(vm.Vector3(0, 0, 1), -0.15),
    );

    return beam;
  }

  // ------------------------------------------------------------
  // BEAM TO DETECTOR
  // ------------------------------------------------------------

  Node _buildLaserBeamToDetector() {
    return box(
      'Laser Beam 3',
      vm.Vector3(3.0, 0.035, 0.035),
      vm.Vector3(5.0, 1.2, 2.5),
      const Color(0xFFFF4A4A),
      roughness: 0.1,
      rotation: vm.Quaternion.axisAngle(vm.Vector3(1, 0, 0), 0.25),
    );
  }

  // ------------------------------------------------------------
  // OPTICAL RAILS
  // ------------------------------------------------------------

  Node _buildOpticalRails() {
    final rails = Node(name: 'Optical Rails');

    rails.add(
      box(
        'Rail 1',
        vm.Vector3(14.0, 0.12, 0.12),
        vm.Vector3(1.0, 0.42, -2.2),
        const Color(0xFFB6BEC6),
        metallic: 0.95,
        roughness: 0.18,
      ),
    );

    rails.add(
      box(
        'Rail 2',
        vm.Vector3(10.0, 0.12, 0.12),
        vm.Vector3(4.0, 0.42, 0.3),
        const Color(0xFFB6BEC6),
        metallic: 0.95,
        roughness: 0.18,
      ),
    );

    return rails;
  }

  // ------------------------------------------------------------
  // POWER SUPPLY
  // ------------------------------------------------------------

  Node _buildPowerSupply() {
    final supply = Node(name: 'Power Supply');

    supply.add(
      box(
        'Power Supply Body',
        vm.Vector3(2.2, 1.4, 1.5),
        vm.Vector3(-5.8, 0.9, 2.7),
        const Color(0xFF252B33),
        metallic: 0.55,
        roughness: 0.3,
      ),
    );

    supply.add(
      box(
        'Display',
        vm.Vector3(0.06, 0.35, 0.65),
        vm.Vector3(-4.65, 1.1, 2.7),
        const Color(0xFF39FF88),
        roughness: 0.15,
      ),
    );

    return supply;
  }

  // ------------------------------------------------------------
  // CABLES
  // ------------------------------------------------------------

  Node _buildCables() {
    final cables = Node(name: 'Cables');

    cables.add(
      box(
        'Cable 1',
        vm.Vector3(5.0, 0.08, 0.08),
        vm.Vector3(0.0, 0.5, 3.0),
        const Color(0xFF15181C),
        roughness: 0.7,
      ),
    );

    cables.add(
      box(
        'Cable 2',
        vm.Vector3(3.0, 0.08, 0.08),
        vm.Vector3(6.0, 0.5, 3.7),
        const Color(0xFF15181C),
        roughness: 0.7,
      ),
    );

    return cables;
  }

  // ------------------------------------------------------------
  // CAMERA CALCULATION
  // ------------------------------------------------------------

  void _updateCamera() {
    final x = distance * math.cos(elevation) * math.sin(azimuth);

    final y = distance * math.sin(elevation);

    final z = distance * math.cos(elevation) * math.cos(azimuth);

    camera.position = vm.Vector3(x, y + 2.0, z);

    camera.target = vm.Vector3(0, 1.0, 0);
  }

  // ------------------------------------------------------------
  // RESET CAMERA
  // ------------------------------------------------------------

  void _resetCamera() {
    setState(() {
      azimuth = -0.65;
      elevation = 0.48;
      distance = 15.0;
      _updateCamera();
    });
  }

  // ------------------------------------------------------------
  // COMPONENT INFORMATION
  // ------------------------------------------------------------

  String _componentDescription() {
    switch (selectedComponent) {
      case 'Ti:Sapphire Laser':
        return 'Ultrafast laser source used to generate the optical beam.';

      case 'Beam Splitter':
        return 'Optical element used to divide the incident beam into separate paths.';

      case 'Collimator':
        return 'Produces a more parallel optical beam from the source.';

      case 'Plano Convex Lens':
        return 'Focusing element used to modify the beam propagation.';

      case 'Cloud Chamber':
        return 'Experimental chamber represented in the optical setup.';

      case 'SFP Module TX':
        return 'Optical transmitter interface.';

      case 'SFP Module RX':
        return 'Optical receiver interface.';

      case 'Scientific Camera':
        return 'Imaging detector for observing the experimental region.';

      case 'Detector':
        return 'Optical detection module.';

      default:
        return '3D optical laboratory component.';
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (!ready)
              const Center(child: CircularProgressIndicator())
            else
              GestureDetector(
                onScaleStart: (details) {
                  startAzimuth = azimuth;
                  startElevation = elevation;
                  startDistance = distance;
                },
                onScaleUpdate: (details) {
                  setState(() {
                    azimuth = startAzimuth - details.focalPointDelta.dx * 0.008;

                    elevation =
                        startElevation + details.focalPointDelta.dy * 0.008;

                    elevation = elevation.clamp(-1.0, 1.0);

                    if (details.scale != 1.0) {
                      distance = startDistance / details.scale;

                      distance = distance.clamp(7.0, 30.0);
                    }

                    _updateCamera();
                  });
                },
                child: SceneView(scene, camera: camera),
              ),

            // TOP HEADER
            Positioned(top: 12, left: 12, right: 12, child: _header()),

            // RIGHT COMPONENT PANEL
            Positioned(
              top: 90,
              right: 14,
              width: 270,
              child: _componentPanel(),
            ),

            // BOTTOM CONTROLS
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: _bottomControls(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xDD0B1626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: const [BoxShadow(blurRadius: 20, spreadRadius: 2)],
      ),
      child: Row(
        children: [
          const Icon(Icons.science, color: Color(0xFF63D7FF), size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OPTICAL EXPERIMENT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Interactive 3D Laboratory',
                  style: TextStyle(fontSize: 12, color: Colors.white60),
                ),
              ],
            ),
          ),
          _statusChip(),
        ],
      ),
    );
  }

  Widget _statusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF103B2A),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF2BD67B)),
      ),
      child: const Row(
        children: [
          Icon(Icons.circle, size: 8, color: Color(0xFF2BD67B)),
          SizedBox(width: 7),
          Text(
            'SYSTEM READY',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _componentPanel() {
    final components = [
      'Ti:Sapphire Laser',
      'Beam Splitter',
      'Collimator',
      'Plano Convex Lens',
      'Cloud Chamber',
      'SFP Module TX',
      'SFP Module RX',
      'Scientific Camera',
      'Detector',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xE60B1626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'COMPONENTS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          ...components.map((component) => _componentButton(component)),
          const Divider(height: 20),
          Text(
            selectedComponent,
            style: const TextStyle(
              color: Color(0xFF63D7FF),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            _componentDescription(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _componentButton(String name) {
    final selected = name == selectedComponent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() {
            selectedComponent = name;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF12344A) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 14,
                color: selected ? const Color(0xFF63D7FF) : Colors.white38,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 11,
                    color: selected ? Colors.white : Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xE60B1626),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.touch_app, size: 18, color: Color(0xFF63D7FF)),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Drag to rotate  •  Pinch to zoom',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ),
          IconButton(
            tooltip: 'Reset view',
            onPressed: _resetCamera,
            icon: const Icon(Icons.center_focus_strong),
          ),
          IconButton(
            tooltip: 'Zoom in',
            onPressed: () {
              setState(() {
                distance = (distance - 1).clamp(7.0, 30.0);
                _updateCamera();
              });
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            tooltip: 'Zoom out',
            onPressed: () {
              setState(() {
                distance = (distance + 1).clamp(7.0, 30.0);
                _updateCamera();
              });
            },
            icon: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
