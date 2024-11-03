import 'package:arprojesi/colors.dart';
import 'package:arprojesi/episode_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeEntryScreen extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.gray,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: width * 0.2),
                child: Text(
                  'creamoney',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.dark,
                    fontFamily: 'Kodchasan',
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(height: width * 0.5),
              Text(
                'Kod gönderildi. \nLütfen gelen kutunuzu kontrol edin.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.dark,
                  fontFamily: "Kodchasan",
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: width * 0.05),
              Container(
                width: width * 0.8,
                height: width * 0.13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.turq,
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: codeController,
                  cursorColor: AppColors.gray,
                  cursorHeight: width * 0.04,
                  style: TextStyle(
                    color: AppColors.gray,
                    fontFamily: "Kodchasan",
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(11),
                    border: InputBorder.none,
                    hintText: 'Kodu Gir',
                    hintStyle: TextStyle(color: AppColors.gray),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppColors.gray,
                    ),
                  ),
                ),
              ),
              SizedBox(height: width * 0.1),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EpisodeOne(),
                    ),
                  );
                },
                child: Text(
                  "ONAYLA",
                  style: TextStyle(
                    color: AppColors.gray,
                    fontFamily: "Kodchasan",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.turq,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
