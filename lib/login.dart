import 'package:arprojesi/colors.dart';
import 'package:arprojesi/db/mongo.dart';
import 'package:arprojesi/register.dart';
import 'package:arprojesi/your_currencies.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailOrUsernameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.gray,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
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
                  ),
                ),
                SizedBox(height: width * 0.2),
                Text(
                  'GİRİŞ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.dark,
                    fontFamily: 'Kodchasan',
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: width * 0.1),
                Text(
                  'E-posta veya kullanıcı adı',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.dark,
                    fontFamily: 'Kodchasan',
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: width * 0.02),
                Container(
                  width: width * 0.8,
                  height: width * 0.13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.05),
                    color: AppColors.turq,
                  ),
                  child: TextField(
                    autofocus: false,
                    controller: emailOrUsernameController,
                    cursorColor: AppColors.gray,
                    cursorHeight: width * 0.04,
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: AppColors.gray,
                      fontFamily: "Kodchasan",
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(width * 0.026),
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.gray,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: width * 0.04),
                Text(
                  'Şifre',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.dark,
                    fontFamily: 'Kodchasan',
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: width * 0.02),
                Container(
                  width: width * 0.8,
                  height: width * 0.13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.05),
                    color: AppColors.turq,
                  ),
                  child: TextField(
                    autofocus: false,
                    obscureText: true,
                    controller: passController,
                    cursorColor: AppColors.gray,
                    cursorHeight: width * 0.04,
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: AppColors.gray,
                      fontFamily: "Kodchasan",
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(width * 0.026),
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.password_rounded,
                        color: AppColors.gray,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: width * 0.06),
                SizedBox(
                  width: width * 0.8,
                  height: width * 0.1,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (emailOrUsernameController.text.isNotEmpty &&
                          passController.text.isNotEmpty) {
                        Future<bool> key = loginUser(
                            emailOrUsernameController.text,
                            passController.text);
                        if (await key) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CurrencyListScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Hatalı giriş!")),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Hatalı giriş!")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.turq,
                    ),
                    child: Text(
                      "Giriş Yap",
                      style: TextStyle(
                        fontSize: width * 0.05,
                        color: AppColors.gray,
                        fontFamily: "Kodchasan",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: keyboardHeight == 0
          ? FloatingActionButton.extended(
              label: Text(
                "Kayıt Ol!",
                style: TextStyle(
                    fontSize: width * 0.05,
                    fontFamily: "Kodchasan",
                    color: AppColors.gray,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppColors.turq,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ),
                );
              },
            )
          : null,
    );
  }
}
