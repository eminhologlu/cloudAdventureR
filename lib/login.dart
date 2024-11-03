import 'package:arprojesi/code_entry.dart';
import 'package:arprojesi/colors.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.gray,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: width * 0.2),
              Text(
                'creamoney',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.dark,
                  fontFamily: 'Kodchasan',
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
              SizedBox(height: width * 0.5),
              Text(
                'BAŞLAMAK İÇİN E-POSTA ADRESİNİ GİR:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.dark,
                  fontFamily: 'Kodchasan',
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              SizedBox(height: width * 0.03),
              Container(
                width: width * 0.8,
                height: width * 0.13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.turq,
                ),
                child: TextField(
                  controller: emailController,
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
                    prefixIcon: Icon(
                      Icons.email_outlined,
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
                      builder: (context) => CodeEntryScreen(),
                    ),
                  );
                },
                child: Text(
                  "KOD GÖNDER",
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
