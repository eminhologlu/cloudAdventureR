import 'dart:async';
import 'dart:typed_data';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:arprojesi/colors.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:io';

class ImageARPage extends StatefulWidget {
  final Uint8List imageData;

  const ImageARPage({super.key, required this.imageData});

  @override
  _ImageARPageState createState() => _ImageARPageState();
}

class _ImageARPageState extends State<ImageARPage> {
  late ARKitController arkitController;
  String? currentImagePath;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ImageARPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageData != oldWidget.imageData) {
      _updateARKitImage();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.gray,
          title: const Text(
            'AR Görüntüleyici',
            style: TextStyle(fontFamily: "Kodchasan"),
          ),
        ),
        body: ARKitSceneView(
          onARKitViewCreated: onARKitViewCreated,
        ),
      );

  /// Writes image data to a uniquely named temporary file
  Future<String> _writeImageDataToTempFile(Uint8List imageData) async {
    final directory = await getTemporaryDirectory();
    final uniqueFileName =
        'temp_image_${DateTime.now().millisecondsSinceEpoch}.png';
    final filePath = '${directory.path}/$uniqueFileName';
    final file = File(filePath);
    await file.writeAsBytes(imageData);
    return filePath;
  }

  Future<void> _updateARKitImage() async {
    if (arkitController == null) return;

    // Write the new image data to a unique temporary file
    final newImagePath = await _writeImageDataToTempFile(widget.imageData);

    // Remove the previous node if it exists
    arkitController.remove('imageNode');

    // Create a new ARKitMaterial with the updated image
    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.lambert,
      diffuse: ARKitMaterialProperty.image(newImagePath),
    );

    // Create a new ARKitPlane
    final plane = ARKitPlane(
      width: 0.3,
      height: 0.2,
      materials: [material],
    );

    // Add a new node to the ARKit scene
    final node = ARKitNode(
      name: 'imageNode',
      geometry: plane,
      position: Vector3(0, 0, -0.5),
    );

    arkitController.add(node);

    // Update the current image path
    currentImagePath = newImagePath;
  }

  void onARKitViewCreated(ARKitController arkitController) async {
    this.arkitController = arkitController;

    // Initialize with the initial image data
    await _updateARKitImage();
  }
}
