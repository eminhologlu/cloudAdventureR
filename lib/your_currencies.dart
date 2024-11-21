import 'package:arprojesi/colors.dart';
import 'package:arprojesi/dashboard.dart';
import 'package:arprojesi/db/mongo.dart';
import 'package:arprojesi/episode_one.dart';
import 'package:arprojesi/login.dart';
import 'package:arprojesi/moneydata.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyListScreen extends StatefulWidget {
  const CurrencyListScreen({super.key});

  @override
  _CurrencyListScreenState createState() => _CurrencyListScreenState();
}

class _CurrencyListScreenState extends State<CurrencyListScreen> {
  Future<List<Moneydata>> _currencyData = Future.value([]);
  String? username;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    username = await getUsername();
    setState(() {
      _currencyData = getUserCurrencyData(username!);
    });
  }

  Future<void> _deleteCurrency(String currencyName) async {
    try {
      await deleteUserCurrencyData(username!, currencyName);
      setState(() {
        _currencyData = getUserCurrencyData(username!);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting currency: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.turq,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EpisodeOne(),
              ),
            );
          },
          child: const Icon(
            Icons.add_box_rounded,
            color: AppColors.gray,
          )),
      backgroundColor: AppColors.gray,
      appBar: AppBar(
        actions: [
          IconButton(
              iconSize: width * 0.07,
              onPressed: () {
                logoutUser();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.power_settings_new_rounded,
                color: AppColors.dark,
              ))
        ],
        leading: const Text(""),
        backgroundColor: AppColors.gray,
        title: Text(
          "Para Birimlerin - ${username ?? 'Loading...'}",
          style:
              const TextStyle(fontFamily: "Kodchasan", color: AppColors.dark),
        ),
      ),
      body: FutureBuilder<List<Moneydata>>(
        future: _currencyData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.turq,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // No data available, show a button
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Daha önce hiç para birimi oluşturmamışsın.',
                      style: TextStyle(
                          fontSize: width * 0.04,
                          fontFamily: "Kodchasan",
                          color: AppColors.turq,
                          fontWeight: FontWeight.w900)),
                  SizedBox(height: width * 0.04),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.turq,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EpisodeOne(),
                        ),
                      );
                    },
                    child: Text('Şimdi para birimini oluştur!',
                        style: TextStyle(
                            fontSize: width * 0.04,
                            fontFamily: "Kodchasan",
                            color: AppColors.gray,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }

          final currencies = snapshot.data!;

          return ListView.builder(
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currency = currencies[index];
              return ListTile(
                tileColor: AppColors.gray,
                title: Text(currency.currencyName,
                    style: TextStyle(
                        fontSize: width * 0.05,
                        color: AppColors.dark,
                        fontFamily: "Kodchasan",
                        fontWeight: FontWeight.w900)),
                subtitle: Text(
                    'Sembol: ${currency.symbol}   Birim: ${currency.unit}',
                    style: TextStyle(
                        fontSize: width * 0.034,
                        fontFamily: "Kodchasan",
                        fontWeight: FontWeight.bold,
                        color: AppColors.turq)),
                trailing: IconButton(
                  iconSize: width * 0.06,
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 242, 121, 103),
                  ),
                  onPressed: () {
                    _deleteCurrency(currency.currencyName);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Dashboard(moneyData: currency),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

Future<String?> getUsername() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}
