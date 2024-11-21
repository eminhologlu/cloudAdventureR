import 'package:arprojesi/colors.dart';
import 'package:arprojesi/db/mongo.dart';
import 'package:arprojesi/login.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController rePassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.gray,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.gray,
        title: Text(
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: width * 0.1),
                Text(
                  'KAYIT',
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
                  'E-posta',
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
                    controller: emailController,
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
                  'Kullanıcı Adı',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.dark,
                    fontFamily: 'Kodchasan',
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    height: 1,
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
                    controller: userNameController,
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
                        Icons.supervised_user_circle_rounded,
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
                    height: 1,
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
                SizedBox(height: width * 0.04),
                Text(
                  'Tekrar Şifre',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.dark,
                    fontFamily: 'Kodchasan',
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    height: 1,
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
                    obscureText: true,
                    controller: rePassController,
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
                SizedBox(height: width * 0.1),
                ElevatedButton(
                  onPressed: () async {
                    if (passController.text == (rePassController.text) &&
                        emailController.text.isNotEmpty &&
                        userNameController.text.isNotEmpty &&
                        passController.text.isNotEmpty) {
                      Future<bool> key = registerUser(emailController.text,
                          userNameController.text, passController.text);
                      if (await key) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Kayıt başarılı!")),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Kullanıcı adı veya e-posta sistemde zaten kayıtlı!")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Tüm bilgileri eksiksiz doldur!")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.turq,
                  ),
                  child: Text(
                    "Kayıt Ol",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      color: AppColors.gray,
                      fontFamily: "Kodchasan",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
