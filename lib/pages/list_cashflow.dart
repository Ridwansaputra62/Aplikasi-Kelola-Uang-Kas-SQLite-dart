import 'package:flutter/material.dart';
import 'package:flutter_buku_kas/models/cash_flow.dart';
import 'package:flutter_buku_kas/services/db_helper.dart';
import 'package:intl/intl.dart';
import 'home.dart';

class CashFlowPage extends StatefulWidget {
  const CashFlowPage({Key? key}) : super(key: key);

  @override
  _CashFlowPageState createState() => _CashFlowPageState();
}

class _CashFlowPageState extends State<CashFlowPage> {
  final DataHelper dataHelper = DataHelper();
  late List<CashFlow> listCashFlow;

  @override
  void initState() {
    super.initState();
    listCashFlow = [];
    initialize();
  }

  Future initialize() async {
    listCashFlow = await dataHelper.selectCashFlow();
    listCashFlow = List.from(listCashFlow.reversed);
    dataHelper.close();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Cashflow'),
        backgroundColor: Colors.white, // Ubah warna header menjadi putih
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: (listCashFlow != null && listCashFlow.isNotEmpty)
                  ? ListView.builder(
                      itemCount: listCashFlow.length,
                      itemBuilder: (context, index) {
                        return _buildCashFlowItem(listCashFlow[index]);
                      },
                    )
                  : const Center(child: Text('Tidak ada data')),
            ),
            const Divider(
              height: 1,
              color: Colors.black,
            ), // Garis pemisah
            _buildTotalBalance(),
          ],
        ),
      ),
    );
  }

  Widget _buildCashFlowItem(CashFlow cashFlow) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildIcon(cashFlow.type),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cashFlow.description ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '').format(cashFlow.amount)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  _buildDateTime(cashFlow.date),
                ],
              ),
            ),
            _buildButtons(cashFlow),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(int? type) {
    return Icon(
      (type == 0) ? Icons.arrow_upward : Icons.arrow_downward,
      color: (type == 0) ? Colors.green : Colors.red,
    );
  }

  Widget _buildButtons(CashFlow cashFlow) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _deleteCashFlow(cashFlow.id!);
          },
        ),
      ],
    );
  }

  Widget _buildTotalBalance() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // Kotak selisih
      ),
      child: FutureBuilder<int>(
        future: calculateTotalBalance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            int balance = snapshot.data!;
            IconData icon =
                balance >= 0 ? Icons.arrow_upward : Icons.arrow_downward;
            Color iconColor = balance >= 0 ? Colors.green : Colors.red;
            String formattedBalance =
                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(balance);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Selisih: $formattedBalance',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDateTime(String? date) {
    try {
      if (date != null) {
        final dateTime = DateTime.parse(date);
        final formattedDateTime = DateFormat('dd MMMM yyyy').format(dateTime);
        return Text(
          formattedDateTime,
          style: const TextStyle(fontSize: 12),
        );
      } else {
        return const SizedBox.shrink();
      }
    } catch (e) {
      print("Error parsing date: $e");
      return const SizedBox.shrink();
    }
  }

  Future<int> calculateTotalBalance() async {
    List<CashFlow> cashFlows = await dataHelper.selectCashFlow();
    int totalIncome = 0;
    int totalExpense = 0;

    for (var flow in cashFlows) {
      if (flow.type == 1) {
        totalIncome += flow.amount!;
      } else {
        totalExpense += flow.amount!;
      }
    }

    return totalExpense - totalIncome;
  }

  void _deleteCashFlow(int id) async {
    await dataHelper.deleteCashFlow(id);
    initialize();
  }
}
