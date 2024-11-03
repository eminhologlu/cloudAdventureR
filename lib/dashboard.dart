import 'dart:convert';
import 'dart:typed_data';
import 'package:arprojesi/ar_viewer.dart';
import 'package:arprojesi/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arprojesi/colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? currencyName;
  String? currencySymbol;
  int? currencyBirim;
  Map<String, String?> selections = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currencyName = prefs.getString('currencyName');
      currencySymbol = prefs.getString('currencySymbol');
      currencyBirim = prefs.getInt('currencyBirim');
      final selectionsString = prefs.getString('selections');
      if (selectionsString != null) {
        selections = Map<String, String?>.from(jsonDecode(selectionsString));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.gray,
        appBar: AppBar(
          backgroundColor: AppColors.gray,
          leading: Icon(
            Icons.currency_exchange_rounded,
            color: AppColors.dark,
          ),
          title: Text("Para Birimin",
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
                      _infoText("ADI", currencyName),
                      _infoText("SEMBOL", currencySymbol),
                      _infoText("BİRİM", currencyBirim?.toString()),
                      SizedBox(height: width * 0.02),
                      Text("BANKNOTLAR", style: _headerStyle),
                      SizedBox(height: width * 0.02),
                      _selectionChips("Banknot"),
                      SizedBox(height: width * 0.02),
                      Text("MADENİ PARALAR", style: _headerStyle),
                      SizedBox(height: width * 0.02),
                      _selectionChips("Metal Para"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: width * 0.1),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TasksPage()),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoText(String label, String? value) {
    return Column(
      children: [
        Text(label, style: _labelStyle),
        Text(value ?? "", style: _valueStyle),
      ],
    );
  }

  Widget _selectionChips(String type) {
    // Filter the selections based on type and convert them to a list
    final items = selections.entries
        .where((entry) => entry.value == type)
        .map((entry) => entry.key)
        .toList();

    // Split the items into chunks of 3
    final rows = <List<String>>[];
    for (var i = 0; i < items.length; i += 3) {
      rows.add(items.sublist(i, i + 3 > items.length ? items.length : i + 3));
    }

    // Build the rows with a maximum of 3 items per row
    return Column(
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: ElevatedButton(
                onPressed: () {
                  _onChipTapped(item);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.extra,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontFamily: "Kodchasan",
                    fontSize: 18,
                    color: AppColors.turq,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  void _onChipTapped(String itemName) async {
    // Retrieve the image data from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? base64Image = prefs.getString('drawing_image_$itemName');

    if (base64Image != null) {
      // Decode the Base64 string to Uint8List
      final Uint8List imageData = base64Decode(base64Image);

      // Navigate to the AR screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageARPage(imageData: imageData),
        ),
      );
    } else {
      // Show error if image not found
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Image not found.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  TextStyle get _headerStyle => TextStyle(
        fontSize: 20,
        fontFamily: "Kodchasan",
        fontWeight: FontWeight.w900,
        color: AppColors.gray,
      );

  TextStyle get _labelStyle => TextStyle(
        fontSize: 20,
        fontFamily: "Kodchasan",
        fontWeight: FontWeight.w900,
        color: AppColors.gray,
      );

  TextStyle get _valueStyle => TextStyle(
        fontSize: 20,
        fontFamily: "Kodchasan",
        fontWeight: FontWeight.w900,
        color: AppColors.dark,
      );
}
