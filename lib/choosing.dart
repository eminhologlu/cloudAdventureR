import 'dart:convert'; // For jsonEncode and jsonDecode
import 'package:arprojesi/colors.dart';
import 'package:arprojesi/design_menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FactorSelectionScreen extends StatefulWidget {
  final int unit;
  const FactorSelectionScreen({Key? key, required this.unit}) : super(key: key);

  @override
  _FactorSelectionScreenState createState() => _FactorSelectionScreenState();
}

class _FactorSelectionScreenState extends State<FactorSelectionScreen> {
  List<int> factors = [];
  Map<int, String?> selections = {};

  @override
  void initState() {
    super.initState();
    calculateFactors(widget.unit);
  }

  void calculateFactors(int number) {
    for (int i = 1; i <= number; i++) {
      if (number % i == 0) {
        factors.add(i);
      }
    }
  }

  void saveSelection(Map<int, String?> selections) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String?> stringSelections =
        selections.map((key, value) => MapEntry(key.toString(), value));
    String selectionsString = jsonEncode(stringSelections);
    await prefs.setString('selections', selectionsString);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.gray,
        appBar: AppBar(
          leading: Icon(Icons.construction_rounded),
          title: Text(
            "Para Birimi Tiplerini Seç",
            style: TextStyle(fontFamily: "Kodchasan"),
          ),
          backgroundColor: AppColors.gray,
        ),
        body: ListView.builder(
          itemCount: factors.length,
          itemBuilder: (context, index) {
            int factor = factors[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$factor",
                    style: TextStyle(
                        color: AppColors.dark,
                        fontFamily: "Kodchasan",
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.06),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (selections[factor] == "Banknot") {
                              selections[factor] = null;
                            } else {
                              selections[factor] = "Banknot";
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selections[factor] == "Banknot"
                              ? AppColors.turq
                              : AppColors.gray,
                        ),
                        child: Text(
                          "Banknot",
                          style: TextStyle(
                              fontFamily: "Kodchasan", color: AppColors.dark),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (selections[factor] == "Metal Para") {
                              selections[factor] = null;
                            } else {
                              selections[factor] = "Metal Para";
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selections[factor] == "Metal Para"
                              ? AppColors.turq
                              : AppColors.gray,
                        ),
                        child: Text(
                          "Metal Para",
                          style: TextStyle(
                              fontFamily: "Kodchasan", color: AppColors.dark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.save,
            color: AppColors.gray,
          ),
          backgroundColor: AppColors.turq,
          onPressed: () async {
            if (selections.isEmpty ||
                selections.values.every((value) => value == null)) {
              final snackBar = SnackBar(
                backgroundColor: AppColors.turq,
                content: const Text('Hiç seçim yapmadın!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.gray,
                        fontFamily: "Kodchasan",
                        fontWeight: FontWeight.bold)),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              saveSelection(selections);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DesignMenu(selections: selections),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
