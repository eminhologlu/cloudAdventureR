import 'package:arprojesi/colors.dart';
import 'package:arprojesi/db/mongo.dart';
import 'package:arprojesi/episode_four.dart';
import 'package:arprojesi/moneydata.dart';
import 'package:flutter/material.dart';

class EpisodeThree extends StatefulWidget {
  const EpisodeThree({super.key});

  @override
  State<EpisodeThree> createState() => _EpisodeThreeState();
}

class _EpisodeThreeState extends State<EpisodeThree> {
  final TextEditingController currencyName = TextEditingController();
  final TextEditingController currencySymbol = TextEditingController();
  final Moneydata moneyData = Moneydata();
  String? username;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    username = await getUsername();
  }

  Future<void> saveCurrency() async {
    moneyData.currencyName = currencyName.text;
    moneyData.symbol = currencySymbol.text;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.turq,
        onPressed: () async {
          await saveCurrency();
          if (currencyName.text.isEmpty && currencySymbol.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Değerler boş olamaz!")),
            );
          } else if (await userHasCurrency(username!, currencyName.text)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text("Daha önce bu isimde para birimi oluşturmuşsun!")),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EpisodeFour(moneyData: moneyData),
              ),
            );
          }
        },
        child: const Icon(
          Icons.arrow_forward,
          color: AppColors.gray,
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
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
                          borderRadius: BorderRadius.circular(width * 0.05),
                          color: AppColors.turq,
                        ),
                        child: TextField(
                          controller: currencyName,
                          cursorColor: AppColors.gray,
                          cursorHeight: width * 0.04,
                          style: const TextStyle(
                            color: AppColors.gray,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Kodchasan",
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(width * 0.027),
                            border: InputBorder.none,
                            hintText: 'Para birimi adını gir',
                            hintStyle: const TextStyle(color: AppColors.gray),
                            prefixIcon: const Icon(
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
                          borderRadius: BorderRadius.circular(width * 0.05),
                          color: AppColors.turq,
                        ),
                        child: TextField(
                          controller: currencySymbol,
                          cursorColor: AppColors.gray,
                          cursorHeight: width * 0.04,
                          style: const TextStyle(
                            color: AppColors.gray,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Kodchasan",
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(width * 0.027),
                            border: InputBorder.none,
                            hintText: 'Sembolünü gir',
                            hintStyle: const TextStyle(color: AppColors.gray),
                            prefixIcon: const Icon(
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
