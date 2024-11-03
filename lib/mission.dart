import 'dart:convert';
import 'package:arprojesi/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mission extends StatefulWidget {
  final int taskNumber;

  const Mission({Key? key, required this.taskNumber}) : super(key: key);

  @override
  State<Mission> createState() => _MissionState();
}

class _MissionState extends State<Mission> {
  late List<Map<String, dynamic>> banknotesAndCoins = [];
  int totalValue = 0;
  Map<int, String> selections = {};

  @override
  void initState() {
    super.initState();
    _loadSelections();
  }

  Future<void> _loadSelections() async {
    final prefs = await SharedPreferences.getInstance();
    final selectionsString = prefs.getString('selections');
    if (selectionsString != null) {
      final Map<String, dynamic> decodedSelections =
          Map<String, dynamic>.from(jsonDecode(selectionsString));
      selections = decodedSelections
          .map((key, value) => MapEntry(int.parse(key), value));
      banknotesAndCoins = selections.entries.map((entry) {
        return {'value': entry.key, 'type': entry.value};
      }).toList();
    } else {
      banknotesAndCoins = [];
    }
    setState(() {});
  }

  void _addValue(int value) {
    setState(() {
      totalValue += value;
      if (totalValue == widget.taskNumber) {
        _showMissionCompleteDialog();
      }
    });
  }

  void _resetTotalValue() {
    setState(() {
      totalValue = 0;
    });
  }

  void _showMissionCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.gray,
        title: Text(
          'Görev Tamamlandı!',
          style: TextStyle(fontFamily: "Kodchasan", color: AppColors.dark),
        ),
        content: Text(
          'Hedefe ulaştınız!',
          style: TextStyle(fontFamily: "Kodchasan", color: AppColors.dark),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Tamam',
              style: TextStyle(color: AppColors.turq, fontFamily: "Kodchasan"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.gray,
      appBar: AppBar(
        backgroundColor: AppColors.gray,
        title: Text(
          'Hedef ${widget.taskNumber}',
          style: TextStyle(
              fontFamily: "Kodchasan",
              fontWeight: FontWeight.bold,
              color: AppColors.dark),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(width * 0.01),
              child: Text(
                'Elindeki banknot veya metal paralarla ${widget.taskNumber} değerine ulaşmaya çalış!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: width * 0.04,
                    fontFamily: "Kodchasan",
                    color: AppColors.dark),
              ),
            ),
            SizedBox(height: width * 0.02),
            Text(
              'Toplam Değer: $totalValue',
              style: TextStyle(
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Kodchasan"),
            ),
            SizedBox(height: width * 0.05),
            DragTarget<Map<String, dynamic>>(
              onAccept: (data) {
                _addValue(data['value']);
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: width * 0.9,
                  height: width * 0.3,
                  decoration: BoxDecoration(
                    color: candidateData.isEmpty
                        ? AppColors.turq
                        : Colors.green[200],
                    border: Border.all(width: width * 0.01),
                    borderRadius:
                        BorderRadius.all(Radius.circular(width * 0.07)),
                  ),
                  child: Center(
                    child: Text('Buraya sürükle!',
                        style: TextStyle(
                            color: AppColors.gray,
                            fontSize: width * 0.05,
                            fontFamily: "Kodchasan")),
                  ),
                );
              },
            ),
            SizedBox(height: width * 0.01),
            Container(
              height: width * 1,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: width * 0.0025,
                  mainAxisSpacing: width * 0.01,
                  crossAxisSpacing: width * 0.01,
                ),
                itemCount: banknotesAndCoins.length,
                itemBuilder: (context, index) {
                  final item = banknotesAndCoins[index];
                  return Draggable<Map<String, dynamic>>(
                    data: item,
                    feedback: Material(
                      child: Container(
                        padding: EdgeInsets.all(width * 0.05),
                        color: AppColors.turq,
                        child: Text(item['type'],
                            style: TextStyle(
                                fontSize: width * 0.04,
                                fontFamily: "Kodchasan",
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark)),
                      ),
                    ),
                    childWhenDragging: Container(),
                    child: Card(
                      color: AppColors.turq,
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item['value'].toString(),
                            style: TextStyle(
                                color: AppColors.dark,
                                fontFamily: "Kodchasan",
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.055),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetTotalValue,
        backgroundColor: AppColors.turq,
        child: Icon(Icons.refresh, color: AppColors.gray),
      ),
    );
  }
}
