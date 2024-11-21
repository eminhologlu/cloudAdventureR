import 'dart:convert';
import 'package:arprojesi/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:arprojesi/moneydata.dart';

class DrawingScreen extends StatefulWidget {
  final double factor;
  final String? type;
  final Moneydata moneyData;

  const DrawingScreen(
      {super.key, required this.factor, this.type, required this.moneyData});

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final DrawingController _drawingController = DrawingController();

  void _clearDrawing() {
    setState(() {
      _drawingController.clear(); // Çizim alanını temizler
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.gray,
      appBar: AppBar(
        backgroundColor: AppColors.gray,
        title: Text(
          "Tasarım: ${widget.type} ${widget.factor}",
          style: TextStyle(
              fontFamily: "Kodchasan",
              fontSize: width * 0.05,
              color: AppColors.dark),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save_rounded,
              color: AppColors.turq,
            ),
            onPressed: () {
              _saveDrawing();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_rounded,
              color: AppColors.dark,
            ),
            onPressed: () {
              _clearDrawing(); // Çizim alanını sıfırlar
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
            Padding(
              padding: EdgeInsets.all(width * 0.05),
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
    try {
      final imageData = await _drawingController.getImageData();
      if (imageData == null) {
        print("Hata: Çizim verisi alınamadı (imageData null).");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Hata: Çizim kaydedilemedi!")),
        );
        return;
      }

      final buffer = imageData.buffer.asUint8List();
      String base64Image = base64Encode(buffer);
      widget.moneyData.imageBase64Map[widget.factor] = base64Image;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Çizim kaydedildi!")),
      );
    } catch (e) {
      print("Hata: Çizim kaydedilirken bir hata oluştu. Detay: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hata: Çizim kaydedilemedi!")),
      );
    } finally {
      Navigator.pop(context);
    }
  }
}

class ColorChoice extends StatelessWidget {
  final Color color;
  final ValueChanged<Color> onSelected;

  const ColorChoice({super.key, required this.color, required this.onSelected});

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
          border: Border.all(color: Colors.black),
        ),
      ),
    );
  }
}
