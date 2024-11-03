import 'package:arprojesi/colors.dart';
import 'package:arprojesi/episode_four.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EpisodeThree extends StatefulWidget {
  const EpisodeThree({super.key});

  @override
  State<EpisodeThree> createState() => _EpisodeThreeState();
}

class _EpisodeThreeState extends State<EpisodeThree> {
  final TextEditingController currencyName = TextEditingController();
  final TextEditingController currencySymbol = TextEditingController();

  Future<void> saveCurrencyData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currencyName', currencyName.text);
    await prefs.setString('currencySymbol', currencySymbol.text);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.turq,
        onPressed: () async {
          await saveCurrencyData();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodeFour(),
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
                image: AssetImage("assets/images/episode3.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: width * 0.25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: width * 0.8,
                        height: width * 0.13,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.turq,
                        ),
                        child: TextField(
                          controller: currencyName,
                          cursorColor: AppColors.gray,
                          cursorHeight: width * 0.04,
                          style: TextStyle(
                            color: AppColors.gray,
                            fontFamily: "Kodchasan",
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(11),
                            border: InputBorder.none,
                            hintText: 'Para birimi adını gir',
                            hintStyle: TextStyle(color: AppColors.gray),
                            prefixIcon: Icon(
                              Icons.abc_rounded,
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: width * 0.05,
                      ),
                      Container(
                        width: width * 0.8,
                        height: width * 0.13,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.turq,
                        ),
                        child: TextField(
                          controller: currencySymbol,
                          cursorColor: AppColors.gray,
                          cursorHeight: width * 0.04,
                          style: TextStyle(
                            color: AppColors.gray,
                            fontFamily: "Kodchasan",
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(11),
                            border: InputBorder.none,
                            hintText: 'Sembolünü gir',
                            hintStyle: TextStyle(color: AppColors.gray),
                            prefixIcon: Icon(
                              Icons.emoji_symbols_rounded,
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: width * 0.1,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
