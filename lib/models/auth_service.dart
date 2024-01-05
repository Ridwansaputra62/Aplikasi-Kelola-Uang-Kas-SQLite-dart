import 'package:flutter/material.dart';
import 'package:flutter_buku_kas/pages/home.dart'; // Sesuaikan dengan path file home.dart
import 'package:flutter_buku_kas/pages/login_page.dart';
import 'package:flutter_buku_kas/pages/registration_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';

  Future<void> setLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isLoggedInKey, value);
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> registerAndLogin(
    String username,
    String password,
    BuildContext context,
  ) async {
    // Simpan status login
    await setLoggedIn(true);

    // Lakukan registrasi user (tambahkan sesuai kebutuhan)
    // ...

    // Navigasi ke halaman home
    
  }
  
  // Fungsi register, sesuaikan sesuai kebutuhan
  Future<void> register(String username, String password) async {
    // Lakukan registrasi user (tambahkan sesuai kebutuhan)
    // ...
  }
}
