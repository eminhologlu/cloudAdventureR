import 'package:arprojesi/choosing.dart';
import 'package:arprojesi/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EpisodeFour extends StatefulWidget {
  const EpisodeFour({super.key});

  @override
  State<EpisodeFour> createState() => _EpisodeFourState();
}

class _EpisodeFourState extends State<EpisodeFour> {
  final TextEditingController currencyBirim = TextEditingController();
  Future<void> saveCurrencyData(int data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currencyBirim', data);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.turq,
          onPressed: () async {
            int unit = int.parse(currencyBirim.text);
            await saveCurrencyData(unit);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FactorSelectionScreen(unit: unit),
              ),
            );
          },
          child: Icon(
            Icons.arrow_forward,
            color: AppColors.gray,
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/episode4.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: width * 0.3),
                  child: Center(
                    child: Container(
                      width: width * 0.8,
                      height: width * 0.13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.turq,
                      ),
                      child: TextField(
                        controller: currencyBirim,
                        cursorColor: AppColors.gray,
                        cursorHeight: width * 0.04,
                        style: TextStyle(
                          color: AppColors.gray,
                          fontFamily: "Kodchasan",
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(11),
                          border: InputBorder.none,
                          hintText: 'Para birimi belirle (10-100)',
                          hintStyle: TextStyle(color: AppColors.gray),
                          prefixIcon: Icon(
                            Icons.money,
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
