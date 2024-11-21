import 'dart:convert';
import 'dart:typed_data';

import 'package:arprojesi/ar_viewer.dart';
import 'package:arprojesi/colors.dart';
import 'package:arprojesi/dashboard.dart';
import 'package:arprojesi/db/mongo.dart';
import 'package:arprojesi/designer.dart';
import 'package:arprojesi/moneydata.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesignMenu extends StatelessWidget {
  final Map<double, String?> selections;
  final Moneydata moneyData;
  const DesignMenu(
      {super.key, required this.selections, required this.moneyData});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.gray,
        appBar: AppBar(
          backgroundColor: AppColors.gray,
          leading: const Icon(Icons.design_services_rounded),
          title: const Text(
            "Tasarım Zamanı",
            style: TextStyle(fontFamily: "Kodchasan", color: AppColors.dark),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: selections.length,
                  itemBuilder: (context, index) {
                    final factor = selections.keys.elementAt(index);
                    final type = selections[factor];

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(
                                "$factor",
                                style: TextStyle(
                                    fontFamily: "Kodchasan",
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.06),
                              ),
                              subtitle: Text(
                                type ?? 'None',
                                style: const TextStyle(
                                    fontFamily: "Kodchasan",
                                    color: AppColors.dark),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.turq),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DrawingScreen(
                                    factor: factor,
                                    type: type,
                                    moneyData: moneyData,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Tasarla",
                              style: TextStyle(
                                  color: AppColors.gray,
                                  fontFamily: "Kodchasan",
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.05),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _saveDrawings(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.turq,
                ),
                child: Text(
                  "Tamamla",
                  style: TextStyle(
                      color: AppColors.gray,
                      fontFamily: "Kodchasan",
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.05),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveDrawings(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? "";
    addUserCurrencyData(username, moneyData);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dashboard(moneyData: moneyData)),
    );
  }
}
