 import 'package:flutter/services.dart';
import 'package:flutter_buku_kas/models/cash_flow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/db_helper.dart';
import 'home.dart';

class InputCashFlowPage extends StatefulWidget {
  const InputCashFlowPage({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<InputCashFlowPage> createState() => _InputCashFlowPageState();
}

class _InputCashFlowPageState extends State<InputCashFlowPage> {
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  void submitData() async {
    // Validasi input nominal
    if (_controllerAmount.text.isEmpty || int.parse(_controllerAmount.text) == 0) {
      // Tampilkan pesan kesalahan jika input kosong atau bernilai 0
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Input nominal tidak valid. Harap masukkan nominal yang valid.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    CashFlow cashFlow = CashFlow(
      amount: int.parse(_controllerAmount.text),
      description: _controllerDescription.text,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      type: widget.type == 'pemasukan' ? 0 : 1, inputTime: '',
    );
    await DataHelper().insertCashFlow(cashFlow);

    // Reset formulir setelah data disimpan
    resetForm();

    // Pindah ke halaman beranda setelah data disimpan
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  void resetForm() {
    setState(() {
      _controllerAmount.clear();
      _controllerDescription.clear();
    });
  }

  Widget _buildDateField() {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          color: Colors.grey,
        ),
        const SizedBox(width: 10),
        Text(
          DateFormat('dd MMMM yyyy').format(DateTime.now()),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              (widget.type == 'pemasukan') ? 'Tambah Pemasukan' : 'Tambah Pengeluaran',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: (widget.type == 'pemasukan') ? Colors.green : Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tanggal',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            _buildDateField(),
            const SizedBox(height: 20),
            const Text(
              'Nominal',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: _controllerAmount,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: Text('Rp '),
                  prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                  hintText: '0',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Keterangan',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: _controllerDescription,
                decoration: const InputDecoration(
                  hintText: 'Makanan',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                resetForm();
              },
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                submitData();
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}