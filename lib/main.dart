// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_buku_kas/models/auth_service.dart';
import 'package:flutter_buku_kas/pages/edit_cashflow.dart';
import 'package:flutter_buku_kas/pages/home.dart';
import 'package:flutter_buku_kas/pages/input_cash_flow.dart';
import 'package:flutter_buku_kas/pages/list_cashflow.dart';
import 'package:flutter_buku_kas/pages/pengaturan.dart';
import 'package:flutter_buku_kas/pages/registration_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override

  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KasKita',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: AuthService().isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return snapshot.data == true
                ? const HomePage()
                : const RegistrationPage();
          }
        },
      ),
      routes: {
        '/pemasukan': (context) => const InputCashFlowPage(type: 'pemasukan'),
        '/pengeluaran': (context) => const InputCashFlowPage(type: 'pengeluaran'),
        '/cashFlow': (context) => const CashFlowPage(),
        '/pengaturan': (context) => const PengaturanPage(),
        '/edit_cashflow': (context) => const EditCashFlowPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
