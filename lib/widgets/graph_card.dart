import 'package:flutter/material.dart';
import 'package:flutter_buku_kas/models/cash_flow.dart';
import 'package:flutter_buku_kas/services/db_helper.dart';
import 'package:intl/intl.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
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
      body: Padding(
        padding: const EdgeInsets.all(8), // Ubah padding menjadi 8
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
          ],
        ),
      ),
    );
  }

  Widget _buildCashFlowItem(CashFlow cashFlow) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4), // Ubah padding menjadi 4
      child: Row(
        children: [
          _buildIcon(cashFlow.type),
          const SizedBox(width: 4), // Ubah SizedBox menjadi 4
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cashFlow.description ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Ubah ukuran font menjadi 16
                ),
              ),
              const SizedBox(height: 2), // Ubah SizedBox menjadi 2
              Text(
                'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '').format(cashFlow.amount)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14, // Ubah ukuran font menjadi 14
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildDate(cashFlow.date),
        ],
      ),
    );
  }

  Widget _buildIcon(int? type) {
    return Icon(
      (type == 0) ? Icons.arrow_upward : Icons.arrow_downward,
      color: (type == 0) ? Colors.green : Colors.red,
      size: 20, // Ubah ukuran icon menjadi 20
    );
  }

  Widget _buildDate(String? date) {
    try {
      if (date != null) {
        final dateTime = DateTime.parse(date);
        final formattedDateTime = DateFormat('dd-MM-yyyy').format(dateTime);
        return Text(
          formattedDateTime,
          style: const TextStyle(fontSize: 12), // Ubah ukuran font menjadi 12
        );
      } else {
        return const SizedBox.shrink();
      }
    } catch (e) {
      print("Error parsing date: $e");
      return const SizedBox.shrink();
    }
  }
}
