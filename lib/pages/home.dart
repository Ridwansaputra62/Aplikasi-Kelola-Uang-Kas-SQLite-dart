import 'package:flutter_buku_kas/models/cash_flow.dart';
import 'package:flutter_buku_kas/models/menu.dart';
import 'package:flutter_buku_kas/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/graph_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
void main() async {
  DataHelper dataHelper = DataHelper();

  // Inisialisasi database
  await dataHelper.initDb();

  // Panggil resetCashFlow pada awal setiap bulan
  await dataHelper.resetCashFlow();
  }

final formatter = NumberFormat("#,##0.00", "en_US");

class _HomePageState extends State<HomePage> {

  int _pengeluaran = 0;
  int _pemasukan = 0;

  late DataHelper dataHelper;
  int count = 0;

  @override
  void initState() {
    dataHelper = DataHelper();
    initData();
    super.initState();
  }

  void initData() async {
    List<CashFlow> listCashFlow = await dataHelper.selectCashFlow();
    for (CashFlow cashFlow in listCashFlow) {
      if (cashFlow.type == 0) {
        _pemasukan += cashFlow.amount!;
      } else {
        _pengeluaran += cashFlow.amount!;
      }
    }
    dataHelper.close();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: const Text(
                'Rangkuman Bulan Ini',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pemasukan',
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Rp ${formatter.format(_pemasukan)}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pengeluaran',
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Rp ${formatter.format(_pengeluaran)}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: height / 40,
            ),
            SizedBox(
              height: height / 4,
              child: const GraphPage(),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                height: height - 450,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildMenuButton(context, Icons.attach_money, 'Tambah Pemasukan', '/pemasukan', Colors.green),
                    _buildMenuButton(context, Icons.money_off, 'Tambah Pengeluaran', '/pengeluaran', Colors.red),
                    _buildMenuButton(context, Icons.bar_chart, 'Detail Cashflow', '/cashFlow', Colors.blue),
                    _buildMenuButton(context, Icons.settings, 'Pengaturan', '/pengaturan', Colors.orange),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  

  Widget _buildMenuButton(BuildContext context, IconData icon, String label, String route, Color color) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        primary: color,
        onPrimary: Colors.white,
      ),
    );
  }
}
