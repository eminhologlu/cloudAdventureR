import 'package:arprojesi/choosing.dart';
import 'package:arprojesi/colors.dart';
import 'package:arprojesi/moneydata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EpisodeFour extends StatefulWidget {
  final Moneydata moneyData;
  const EpisodeFour({super.key, required this.moneyData});

  @override
  State<EpisodeFour> createState() => _EpisodeFourState();
}

class _EpisodeFourState extends State<EpisodeFour> {
  final TextEditingController currencyBirim = TextEditingController();

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
            if (9 < unit && unit < 101) {
              widget.moneyData.unit = unit;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FactorSelectionScreen(
                      unit: unit, moneyData: widget.moneyData),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("10-100 arasında sayı girmelisin!")),
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
                        borderRadius: BorderRadius.circular(width * 0.05),
                        color: AppColors.turq,
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: currencyBirim,
                        cursorColor: AppColors.gray,
                        cursorHeight: width * 0.04,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray,
                          fontFamily: "Kodchasan",
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(width * 0.027),
                          border: InputBorder.none,
                          hintText: 'Para birimi belirle (10-100)',
                          hintStyle: const TextStyle(color: AppColors.gray),
                          prefixIcon: const Icon(
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
