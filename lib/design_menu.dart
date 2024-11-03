import 'package:arprojesi/colors.dart';
import 'package:arprojesi/dashboard.dart';
import 'package:arprojesi/designer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesignMenu extends StatelessWidget {
  final Map<int, String?> selections;

  const DesignMenu({Key? key, required this.selections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.gray,
        appBar: AppBar(
          backgroundColor: AppColors.gray,
          leading: Icon(Icons.design_services_rounded),
          title: Text(
            "Tasarım Zamanı",
            style: TextStyle(fontFamily: "Kodchasan"),
          ),
        ),
        body: SafeArea(
          // Wrap body in SafeArea
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: selections.length,
                  itemBuilder: (context, index) {
                    final factor = selections.keys.elementAt(index);
                    final type = selections[factor];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
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
                                "${type ?? 'None'}",
                                style: TextStyle(fontFamily: "Kodchasan"),
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
                child: Text(
                  "Tamamla",
                  style: TextStyle(
                      color: AppColors.gray,
                      fontFamily: "Kodchasan",
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.05),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.turq, // or any color you want
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveDrawings(BuildContext context) async {
    // After saving, navigate to the Dashboard screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Dashboard()),
    );
  }
}
