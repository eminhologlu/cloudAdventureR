import 'package:arprojesi/colors.dart';
import 'package:arprojesi/moneydata.dart';
import 'package:flutter/material.dart';

class Mission extends StatefulWidget {
  final double taskNumber;
  final Moneydata moneyData;

  const Mission({super.key, required this.taskNumber, required this.moneyData});

  @override
  State<Mission> createState() => _MissionState();
}

class _MissionState extends State<Mission> {
  double totalValue = 0;

  void _addValue(double value) {
    setState(() {
      totalValue += value;

      // Hata toleransı (epsilon) değeri
      const epsilon = 0.0001;

      // Hedef değer ile toplam değeri epsilon ile karşılaştırma
      if ((totalValue - widget.taskNumber).abs() < epsilon) {
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
        title: const Text(
          'Görev Tamamlandı!',
          style: TextStyle(fontFamily: "Kodchasan", color: AppColors.dark),
        ),
        content: const Text(
          'Hedefe ulaştınız!',
          style: TextStyle(fontFamily: "Kodchasan", color: AppColors.dark),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
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
          style: const TextStyle(
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
              'Toplam Değer: ${totalValue.toStringAsFixed(2)}',
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
            SizedBox(
              height: width * 1,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: width * 0.0025,
                  mainAxisSpacing: width * 0.01,
                  crossAxisSpacing: width * 0.01,
                ),
                itemCount: widget.moneyData.selectedCurrencyTypes.length,
                itemBuilder: (context, index) {
                  final item = widget.moneyData.selectedCurrencyTypes.entries
                      .elementAt(index);
                  return Draggable<Map<String, dynamic>>(
                    data: {
                      'value': item.key,
                      'type': item.value,
                    },
                    feedback: Material(
                      child: Container(
                        padding: EdgeInsets.all(width * 0.05),
                        color: AppColors.turq,
                        child: Text(item.value.toString(),
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
                      elevation: width * 0.02,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.key.toString(),
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
        child: const Icon(Icons.refresh, color: AppColors.gray),
      ),
    );
  }
}
