import 'package:flutter/material.dart';
import 'package:arprojesi/colors.dart';
import 'package:arprojesi/design_menu.dart';
import 'package:arprojesi/moneydata.dart';

class FactorSelectionScreen extends StatefulWidget {
  final int unit;
  final Moneydata moneyData;
  const FactorSelectionScreen(
      {super.key, required this.unit, required this.moneyData});

  @override
  _FactorSelectionScreenState createState() => _FactorSelectionScreenState();
}

class _FactorSelectionScreenState extends State<FactorSelectionScreen> {
  List<double> factors = [];
  Map<double, String?> selections = {};

  @override
  void initState() {
    super.initState();
    calculateFactors(widget.unit);
  }

  void calculateFactors(int number) {
    for (int i = 1; i <= number; i++) {
      if (number % i == 0) {
        factors.add(i.toDouble());
      }
    }
  }

  void saveSelection(Map<double, String?> selections) async {
    widget.moneyData.selectedCurrencyTypes =
        selections.map((key, value) => MapEntry(key.toDouble(), value));
  }

  void addNewFactor(double newUnit) {
    const double tolerance = 1e-6; // Small tolerance value

    // Check if the new unit is a valid factor
    bool isFactor = ((widget.unit / newUnit) % 1).abs() < tolerance;
    bool isMultiple = ((newUnit / widget.unit) % 1).abs() < tolerance;

    // Check if the value is already in the list
    bool isAlreadyPresent = factors.contains(newUnit);

    if (isFactor || isMultiple) {
      if (!isAlreadyPresent) {
        setState(() {
          factors.add(newUnit); // Add the factor to the list
        });
      } else {
        // Show a message if the factor already exists
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.turq,
            content: Text(
              'Bu değer zaten eklenmiş!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.gray,
                fontFamily: "Kodchasan",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    } else {
      // Show a message if the value is not a valid factor
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.turq,
          content: Text(
            'Girilen değer tam çarpan değil!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.gray,
              fontFamily: "Kodchasan",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.gray,
      appBar: AppBar(
        leading: const Icon(Icons.construction_rounded),
        title: const Text(
          "Para Birimi Tiplerini Seç",
          style: TextStyle(fontFamily: "Kodchasan"),
        ),
        backgroundColor: AppColors.gray,
      ),
      body: ListView.builder(
        itemCount: factors.length,
        itemBuilder: (context, index) {
          double factor = factors[index];
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: width * 0.013, horizontal: width * 0.04),
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
                      child: const Text(
                        "Banknot",
                        style: TextStyle(
                            fontFamily: "Kodchasan", color: AppColors.dark),
                      ),
                    ),
                    SizedBox(width: width * 0.03),
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
                      child: const Text(
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: AppColors.turq,
            onPressed: () async {
              if (selections.isEmpty ||
                  selections.values.every((value) => value == null)) {
                const snackBar = SnackBar(
                  backgroundColor: AppColors.turq,
                  content: Text('Hiç seçim yapmadın!',
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
                    builder: (context) => DesignMenu(
                        selections: selections, moneyData: widget.moneyData),
                  ),
                );
              }
            },
            child: const Icon(
              Icons.save,
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: AppColors.turq,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  double? newUnit;
                  return AlertDialog(
                    title: const Text(
                      "Yeni Birim Ekle",
                      style: TextStyle(fontFamily: "Kodchasan"),
                    ),
                    content: TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        // Replace commas with dots for consistency
                        String normalizedValue = value.replaceAll(',', '.');
                        newUnit = double.tryParse(normalizedValue);
                      },
                      decoration: const InputDecoration(
                        hintText: "Birim girin (örn: 0.33)",
                        hintStyle: TextStyle(fontFamily: "Kodchasan"),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          "İptal",
                          style: TextStyle(fontFamily: "Kodchasan"),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          const double tolerance =
                              1e-6; // Small tolerance value
                          // Validate and add the new factor if valid
                          if (newUnit != null &&
                              (((widget.unit / newUnit!).abs() % 1 <
                                      tolerance) ||
                                  ((newUnit! / widget.unit) % 1).abs() <
                                      tolerance)) {
                            setState(() {
                              if (!factors.contains(newUnit)) {
                                factors.add(
                                    newUnit!); // Add the factor to the list
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: AppColors.turq,
                                    content: Text(
                                      'Bu birim zaten mevcut!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.gray,
                                        fontFamily: "Kodchasan",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            });
                            Navigator.of(context).pop(); // Close the dialog
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: AppColors.turq,
                                content: Text(
                                  'Girilen değer ne tam çarpan ne de kat!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.gray,
                                    fontFamily: "Kodchasan",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Ekle",
                          style: TextStyle(fontFamily: "Kodchasan"),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Icon(
              Icons.add,
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}
