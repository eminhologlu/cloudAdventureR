import 'dart:convert';
import 'package:arprojesi/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawingScreen extends StatefulWidget {
  final int factor;
  final String? type;

  const DrawingScreen({Key? key, required this.factor, this.type})
      : super(key: key);

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final DrawingController _drawingController = DrawingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray,
      appBar: AppBar(
        backgroundColor: AppColors.gray,
        title: Text("Tasarım: ${widget.type} ${widget.factor}"),
        actions: [
          IconButton(
            icon: Icon(Icons.save_rounded),
            onPressed: () {
              _saveDrawing();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: DrawingBoard(
                controller: _drawingController,
                background:
                    Container(width: 400, height: 200, color: Colors.white),
                showDefaultActions: true,
                showDefaultTools: true,
              ),
            ),
            // Color Picker
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ColorChoice(color: Colors.red, onSelected: selectColor),
                  ColorChoice(color: Colors.green, onSelected: selectColor),
                  ColorChoice(color: Colors.blue, onSelected: selectColor),
                  ColorChoice(color: Colors.yellow, onSelected: selectColor),
                  ColorChoice(color: Colors.black, onSelected: selectColor),
                  ColorChoice(color: Colors.orange, onSelected: selectColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectColor(Color color) {
    setState(() {
      _drawingController.setStyle(color: color);
    });
  }

  Future<void> _saveDrawing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the drawing as JSON
    String jsonData = const JsonEncoder.withIndent('  ')
        .convert(_drawingController.getJsonList());
    await prefs.setString('drawing_json_${widget.factor}', jsonData);
    print("Çizim JSON kaydedildi: $jsonData");

    // Get image data
    final imageData = await _drawingController.getImageData();
    final buffer = imageData?.buffer.asUint8List();

    if (buffer != null) {
      // Encode the image data as Base64
      String base64Image = base64Encode(buffer);

      // Save the Base64 string in SharedPreferences
      await prefs.setString('drawing_image_${widget.factor}', base64Image);
      print("Çizim JPEG olarak kaydedildi: $base64Image");

      // Show a confirmation message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Çizim kaydedildi!")),
      );
    } else {
      print("Çizim kaydedilemedi, imageData null.");
    }
  }
}

class ColorChoice extends StatelessWidget {
  final Color color;
  final ValueChanged<Color> onSelected;

  const ColorChoice({Key? key, required this.color, required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => onSelected(color),
      child: Container(
        width: width * 0.06,
        height: width * 0.06,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}
