import 'dart:math';
import 'package:arprojesi/colors.dart';
import 'package:arprojesi/mission.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<int> _taskNumbers = [];

  @override
  void initState() {
    super.initState();
    _generateRandomTasks();
  }

  void _generateRandomTasks() {
    // Generate 10 random numbers from 1 to 100
    for (var i = 0; i < 10; i++) {
      _taskNumbers.add(Random().nextInt(100) + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.gray,
      appBar: AppBar(
        backgroundColor: AppColors.gray,
        title: Text(
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
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
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
                  builder: (context) =>
                      Mission(taskNumber: _taskNumbers[index]),
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
