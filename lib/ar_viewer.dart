import 'dart:async';
import 'dart:typed_data';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:io';

class ImageARPage extends StatefulWidget {
  final Uint8List imageData; // Image data passed from SharedPreferences

  const ImageARPage({Key? key, required this.imageData}) : super(key: key);

  @override
  _ImageARPageState createState() => _ImageARPageState();
}

class _ImageARPageState extends State<ImageARPage> {
  late ARKitController arkitController;
  Timer? timer;

  @override
  void dispose() {
    arkitController.dispose(); // Only dispose of the ARKit controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('AR Image View')),
        body: ARKitSceneView(
          onARKitViewCreated: onARKitViewCreated,
        ),
      );

  Future<String> _writeImageDataToTempFile(Uint8List imageData) async {
    // Get the temporary directory of the app
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/temp_image.png';
    // Write the image data to a file
    final file = File(filePath);
    await file.writeAsBytes(imageData);
    return filePath;
  }

  void onARKitViewCreated(ARKitController arkitController) async {
    this.arkitController = arkitController;

    // Write image data to a temporary file
    final imagePath = await _writeImageDataToTempFile(widget.imageData);

    // Create a material with the image from the temporary file
    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.lambert,
      diffuse: ARKitMaterialProperty.image(imagePath), // Use the temp file path
    );

    // Create a plane and assign the material
    final plane = ARKitPlane(
      width: 0.5,
      height: 0.5,
      materials: [material],
    );

    // Create a node with the plane
    final node = ARKitNode(
      geometry: plane,
      position: Vector3(0, 0, -0.5), // Position in front of the camera
    );

    // Add the node to the ARKit scene
    arkitController.add(node);

    // Start infinite rotation
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final rotation = node.eulerAngles;
      rotation.y += 0.01; // Rotate around Y-axis continuously
      node.eulerAngles = rotation;
    });
  }
}
