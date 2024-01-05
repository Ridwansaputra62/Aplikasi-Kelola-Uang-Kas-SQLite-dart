import 'package:flutter_buku_kas/models/cash_flow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailCard extends StatelessWidget {
  const DetailCard({Key? key, required this.cashFlow}) : super(key: key);
  final CashFlow cashFlow;

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final formatterCurrency = NumberFormat("#,##0.00", "en_US");

    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (cashFlow.type == 0)
                    ? '[+] Rp ${formatterCurrency.format(cashFlow.amount)}'
                    : '[-] Rp ${formatterCurrency.format(cashFlow.amount)}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                cashFlow.description.toString(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                formatter.format(DateTime.parse(cashFlow.date!)).toString(),
                style: const TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ],
          ),
          Icon(
            (cashFlow.type == 0)
                ? Icons.upload
                : Icons.download,
            color: (cashFlow.type == 0) ? Colors.greenAccent[400] : Colors.redAccent[400],
            size: 50,
          ),
        ],
      ),
    );
  }
}
