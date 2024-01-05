import 'package:flutter/services.dart';
import 'package:flutter_buku_kas/models/cash_flow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/db_helper.dart';
import 'list_cashflow.dart';

class EditCashFlowPage extends StatefulWidget {
  const EditCashFlowPage({Key? key}) : super(key: key);

  @override
  _EditCashFlowPageState createState() => _EditCashFlowPageState();
}

class _EditCashFlowPageState extends State<EditCashFlowPage> {
  final DataHelper dataHelper = DataHelper();
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadCashFlowData();
  }

  void loadCashFlowData() async {
    // Menggunakan ModalRoute untuk mendapatkan argumen dari Navigator
    final cashFlowId = ModalRoute.of(context)!.settings.arguments as int;

    CashFlow cashFlow = await dataHelper.getCashFlow(cashFlowId);
    setState(() {
      _controllerAmount.text = cashFlow.amount.toString();
      _controllerDescription.text = cashFlow.description ?? '';
      selectedDate = DateTime.parse(cashFlow.date!);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void updateCashFlow() async {
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

    // Menggunakan ModalRoute untuk mendapatkan argumen dari Navigator
    final cashFlowId = ModalRoute.of(context)!.settings.arguments as int;

    CashFlow updatedCashFlow = CashFlow(
      id: cashFlowId,
      amount: int.parse(_controllerAmount.text),
      description: _controllerDescription.text,
      date: DateFormat('yyyy-MM-dd').format(selectedDate),
      inputTime: '',
    );

    await dataHelper.updateCashFlow(updatedCashFlow);

    // Kembali ke halaman list setelah data diperbarui
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => CashFlowPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Cashflow'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Edit Cashflow',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tanggal',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat('dd MMMM yyyy').format(selectedDate),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                updateCashFlow();
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
