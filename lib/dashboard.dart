import 'dart:convert';
import 'dart:typed_data';
import 'package:arprojesi/ar_viewer.dart';
import 'package:arprojesi/db/mongo.dart';
import 'package:arprojesi/moneydata.dart';
import 'package:arprojesi/tasks_page.dart';
import 'package:arprojesi/your_currencies.dart';
import 'package:flutter/material.dart';
import 'package:arprojesi/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  final Moneydata moneyData;
  Dashboard({Key? key, required this.moneyData}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? currencyName;
  String? currencySymbol;
  int? currencyBirim;
  Map<double, String?> selections = {};
  Map<double, String> base64Map = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> _loadData() async {
    setState(() {
      currencyName = widget.moneyData.currencyName;
      currencySymbol = widget.moneyData.symbol;
      currencyBirim = widget.moneyData.unit;
      selections = widget.moneyData.selectedCurrencyTypes;
      base64Map = widget.moneyData.imageBase64Map;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    TextStyle headerStyle = TextStyle(
      fontSize: width * 0.05,
      fontFamily: "Kodchasan",
      fontWeight: FontWeight.w900,
      color: AppColors.gray,
    );

    TextStyle labelStyle = TextStyle(
      fontSize: width * 0.05,
      fontFamily: "Kodchasan",
      fontWeight: FontWeight.w900,
      color: AppColors.gray,
    );

    TextStyle valueStyle = TextStyle(
      fontSize: width * 0.05,
      fontFamily: "Kodchasan",
      fontWeight: FontWeight.w900,
      color: AppColors.dark,
    );

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.gray,
        appBar: AppBar(
          backgroundColor: AppColors.gray,
          leading: const Text(""),
          actions: [
            IconButton(
                iconSize: width * 0.08,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CurrencyListScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.dataset_rounded,
                  color: AppColors.dark,
                ))
          ],
          title: const Text("Para Birimin",
              style: TextStyle(fontFamily: "Kodchasan", color: AppColors.dark)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width * 0.9,
                height: width * 1.3,
                decoration: BoxDecoration(
                  color: AppColors.turq,
                  borderRadius: BorderRadius.circular(width * 0.1),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: width * 0.02),
                      _infoText("ADI", currencyName, labelStyle, valueStyle),
                      _infoText(
                          "SEMBOL", currencySymbol, labelStyle, valueStyle),
                      _infoText("BİRİM", currencyBirim?.toString(), labelStyle,
                          valueStyle),
                      SizedBox(height: width * 0.02),
                      Text("BANKNOTLAR", style: headerStyle),
                      SizedBox(height: width * 0.02),
                      _selectionChips("Banknot", width),
                      SizedBox(height: width * 0.02),
                      Text("MADENİ PARALAR", style: headerStyle),
                      SizedBox(height: width * 0.02),
                      _selectionChips("Metal Para", width),
                    ],
                  ),
                ),
              ),
              SizedBox(height: width * 0.1),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TasksPage(moneyData: widget.moneyData)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.turq,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.1),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.1, vertical: width * 0.04),
                ),
                child: Text(
                  "GÖREVLER",
                  style: TextStyle(
                    fontFamily: "Kodchasan",
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gray,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoText(
      String label, String? value, TextStyle labelStyle, TextStyle valueStyle) {
    return Column(
      children: [
        Text(label, style: labelStyle),
        Text(value ?? "", style: valueStyle),
      ],
    );
  }

  Widget _selectionChips(String type, double width) {
    final items = selections.entries
        .where((entry) => entry.value == type)
        .map((entry) => entry.key)
        .toList();

    final rows = <List<double>>[];
    for (var i = 0; i < items.length; i += 3) {
      rows.add(items.sublist(i, i + 3 > items.length ? items.length : i + 3));
    }

    return Column(
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((item) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
              child: ElevatedButton(
                onPressed: () {
                  _onChipTapped(item, width);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.extra,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.01, vertical: width * 0.015),
                ),
                child: Row(
                  children: [
                    Text(
                      item.toString(),
                      style: TextStyle(
                        fontFamily: "Kodchasan",
                        fontSize: width * 0.05,
                        color: AppColors.turq,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Icon(
                      Icons.camera_enhance_rounded,
                      color: AppColors.gray,
                      size: width * 0.05,
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  void _onChipTapped(double itemName, double width) async {
    String? base64Image = base64Map[itemName];
    if (base64Image != null) {
      Uint8List imageData = base64Decode(base64Image);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageARPage(imageData: imageData),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Hata',
            style: TextStyle(
                fontFamily: "Kodchasan",
                fontSize: width * 0.06,
                color: AppColors.dark,
                fontWeight: FontWeight.w900),
          ),
          content: Text(
            'Bu para birimin için tasarım oluşturmamışsın!',
            style: TextStyle(
                fontFamily: "Kodchasan",
                fontSize: width * 0.04,
                color: AppColors.dark,
                fontWeight: FontWeight.w400),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Kapat',
                style: TextStyle(
                    fontFamily: "Kodchasan",
                    fontSize: width * 0.04,
                    color: AppColors.turq,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }
  }
}
