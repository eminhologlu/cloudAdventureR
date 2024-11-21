import 'dart:math';
import 'package:arprojesi/colors.dart';
import 'package:arprojesi/mission.dart';
import 'package:arprojesi/moneydata.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  final Moneydata moneyData;
  const TasksPage({super.key, required this.moneyData});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<double> _taskNumbers = [];

  @override
  void initState() {
    super.initState();
    _generateRandomTasks();
  }

  void _generateRandomTasks() {
    int integerCount = 0;
    int decimalCount = 0;
    const totalTasks = 20; // toplam görev sayısı

    while (integerCount + decimalCount < totalTasks) {
      double newTaskNumber;

      if (integerCount < totalTasks ~/ 2) {
        // Tam sayı üret (örneğin 100, 20, 40)
        newTaskNumber = Random().nextInt(100) + 1.0;
        integerCount++;
      } else {
        // Ondalıklı sayı üret (örneğin 20.1, 40.5, 90.9)
        newTaskNumber =
            (Random().nextInt(100) + 1.0) + (Random().nextInt(10) * 0.1);
        decimalCount++;
      }

      // Sayının zaten listede olup olmadığını kontrol et
      if (!_taskNumbers.contains(newTaskNumber)) {
        _taskNumbers.add(newTaskNumber);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.gray,
      appBar: AppBar(
        backgroundColor: AppColors.gray,
        title: const Text(
          'Görevler',
          style: TextStyle(
              fontFamily: "Kodchasan",
              fontWeight: FontWeight.w900,
              color: AppColors.dark),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: width * 0.008,
          crossAxisSpacing: width * 0.02,
          mainAxisSpacing: width * 0.02,
        ),
        padding: EdgeInsets.all(width * 0.03),
        itemCount: _taskNumbers.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.turq,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.2),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Mission(
                    taskNumber: _taskNumbers[index],
                    moneyData: widget.moneyData,
                  ),
                ),
              );
            },
            child: Text(
              'Hedef: ${_taskNumbers[index]}',
              style: TextStyle(
                  color: AppColors.gray,
                  fontFamily: "Kodchasan",
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.05),
            ),
          );
        },
      ),
    );
  }
}
