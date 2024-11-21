import 'package:arprojesi/moneydata.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>?> getBase64Map(
    String username, String currencyName) async {
  final dbUri = dotenv.env['MONGO_DB_URI'];

  // MongoDB bağlantısını oluştur
  final db = await Db.create(dbUri!);
  await db.open();

  try {
    // Koleksiyon referansı
    final collection = db.collection('user_currencies');

    // Kullanıcı adı ve para birimi adına göre dökümanı bul
    final userDoc = await collection.findOne({
      'username': username,
      'currencyName': currencyName,
    });

    if (userDoc != null && userDoc['imageBase64Map'] != null) {
      // imageBase64Map'i al ve liste olarak ata
      final imageBase64Map = userDoc['imageBase64Map'] as List<dynamic>;

      // Listeyi Map'e dönüştür
      final Map<String, String> base64Map = {
        for (var item in imageBase64Map)
          item['key'] as String: item['base64'] as String
      };

      return base64Map;
    } else {
      print('Kullanıcı veya para birimi bulunamadı.');
      return null;
    }
  } catch (e) {
    print('Hata: $e');
    return null;
  } finally {
    await db.close();
  }
}

Future<bool> registerUser(
    String email, String username, String password) async {
  final dbUri = dotenv.env['MONGO_DB_URI'];
  if (dbUri == null) {
    print('MongoDB URI not found in .env file');
    return false;
  }

  final db = await Db.create(dbUri);
  await db.open();
  final usersCollection = db.collection('users');

  try {
    final existingUser = await usersCollection.findOne(
      where.eq('email', email).or(where.eq('username', username)),
    );

    if (existingUser != null) {
      print('User with this email or username already exists');
      await db.close();
      return false;
    }

    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    await usersCollection.insert({
      'email': email,
      'username': username,
      'password': hashedPassword,
    });

    print('User registered successfully');
    await db.close();
    return true;
  } catch (e) {
    print('Error during registration: $e');
    await db.close();
    return false;
  }
}

Future<bool> loginUser(String usernameOrEmail, String password) async {
  final dbUri = dotenv.env['MONGO_DB_URI'];
  if (dbUri == null) {
    print('MongoDB URI not found in .env file');
    return false;
  }

  final db = await Db.create(dbUri);
  await db.open();
  final usersCollection = db.collection('users');

  final hashedPassword = sha256.convert(utf8.encode(password)).toString();

  final user = await usersCollection.findOne(where
      .eq('password', hashedPassword)
      .and(where.eq('email', usernameOrEmail))
      .or(where.eq('username', usernameOrEmail)));

  await db.close();

  if (user != null) {
    print('Login successful');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', user['username']);
    await prefs.setBool('isLoggedIn', true);

    return true;
  } else {
    print('Invalid username/email or password');
    return false;
  }
}

Future<void> logoutUser() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('username');
  await prefs.setBool('isLoggedIn', false);
  print('User logged out');
}

Future<void> addUserCurrencyData(String username, Moneydata moneydata) async {
  final dbUri = dotenv.env['MONGO_DB_URI'];
  if (dbUri == null) {
    print('MongoDB URI not found in .env file');
    return;
  }

  final db = await Db.create(dbUri);
  await db.open();
  final userCurrencyCollection = db.collection('user_currencies');

  try {
    final selectedCurrencyTypesList = moneydata.selectedCurrencyTypes.entries
        .map((e) => {'key': e.key.toString(), 'value': e.value})
        .toList();

    final imageBase64MapList = moneydata.imageBase64Map.entries
        .map((e) => {'key': e.key.toString(), 'base64': e.value})
        .toList();

    final currencyData = {
      'username': username,
      'currencyName': moneydata.currencyName,
      'symbol': moneydata.symbol,
      'unit': moneydata.unit,
      'selectedCurrencyTypes': selectedCurrencyTypesList,
      'imageBase64Map': imageBase64MapList,
    };

    // Insert the data
    await userCurrencyCollection.insert(currencyData);
    print('Currency data added for user $username successfully');
  } catch (e) {
    print('Error adding currency data: $e');
  } finally {
    await db.close();
  }
}

Future<List<Moneydata>> getUserCurrencyData(String username) async {
  final dbUri = dotenv.env['MONGO_DB_URI'];
  if (dbUri == null) {
    print('MongoDB URI not found in .env file');
    return [];
  }

  final db = await Db.create(dbUri);
  await db.open();
  final userCurrencyCollection = db.collection('user_currencies');

  try {
    final result = await userCurrencyCollection
        .find(where.eq('username', username))
        .toList();

    if (result.isEmpty) {
      return [];
    }

    return result.map((doc) {
      return Moneydata(
        currencyName: doc['currencyName'] ?? '',
        symbol: doc['symbol'] ?? '',
        unit: doc['unit'] ?? 0,
        selectedCurrencyTypes:
            _mapToDoubleStringg(doc['selectedCurrencyTypes']),
        imageBase64Map: _mapToDoubleString(doc['imageBase64Map']),
      );
    }).toList();
  } catch (e) {
    print('Error retrieving currency data: $e');
    return [];
  } finally {
    await db.close();
  }
}

Map<double, String> _mapToDoubleString(dynamic input) {
  if (input is List) {
    // Handle List of objects like [{'key': '1', 'base64': '...'}, ...]
    return {
      for (var item in input)
        if (item['key'] != null && item['base64'] != null)
          double.tryParse(item['key'].toString()) ?? 0.0:
              item['base64'].toString(),
    };
  }
  return {};
}

Map<double, String> _mapToDoubleStringg(dynamic input) {
  if (input is List) {
    // Handle List of objects like [{'key': '1', 'base64': '...'}, ...]
    return {
      for (var item in input)
        if (item['key'] != null && item['value'] != null)
          double.tryParse(item['key'].toString()) ?? 0.0:
              item['value'].toString(),
    };
  }
  return {};
}

Map<double, String> _mapToIntString(dynamic input) {
  if (input is List) {
    return {
      for (var item in input) double.parse(item['key']): item['value'] ?? ''
    };
  }
  return {};
}

Future<String?> getUsername() async {
  final prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username');
  return username;
}

Future<bool> userHasCurrency(String username, String currencyName) async {
  final dbUri = dotenv.env['MONGO_DB_URI'];
  if (dbUri == null) {
    print('MongoDB URI not found in .env file');
    return false;
  }

  final db = await Db.create(dbUri);
  await db.open();
  final userCurrencyCollection = db.collection('user_currencies');

  try {
    final result = await userCurrencyCollection
        .findOne({'username': username, 'currencyName': currencyName});

    if (result != null) {
      print('User $username has the currency $currencyName');
      return true;
    } else {
      print('User $username does not have the currency $currencyName');
      return false;
    }
  } catch (e) {
    print('Error checking user currency: $e');
    return false;
  } finally {
    await db.close();
  }
}

Future<void> deleteUserCurrencyData(
    String username, String currencyName) async {
  final dbUri = dotenv.env['MONGO_DB_URI'];
  if (dbUri == null) {
    print('MongoDB URI not found in .env file');
    return;
  }

  final db = await Db.create(dbUri);
  await db.open();
  final userCurrencyCollection = db.collection('user_currencies');

  try {
    final result = await userCurrencyCollection.remove({
      'username': username,
      'currencyName': currencyName,
    });

    if (result['n'] > 0) {
      print(
          'Currency data for $currencyName deleted successfully for user $username');
    } else {
      print('No matching currency data found to delete.');
    }
  } catch (e) {
    print('Error deleting currency data: $e');
  } finally {
    await db.close();
  }
}
