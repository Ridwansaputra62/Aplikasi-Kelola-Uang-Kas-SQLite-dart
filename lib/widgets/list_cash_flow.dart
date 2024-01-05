import 'package:flutter/material.dart';
import 'package:flutter_buku_kas/models/cash_flow.dart';
import '../services/db_helper.dart';

class ListCashFlow extends StatefulWidget {
  final List<CashFlow> cashFlows;
  final void Function(int id) onDelete;
  final void Function(int id) onEdit;

  const ListCashFlow({
    Key? key,
    required this.cashFlows,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<ListCashFlow> createState() => _ListCashFlowState();
}

class _ListCashFlowState extends State<ListCashFlow> {
  late List<CashFlow> listCashFlow;

  Future<void> initialize() async {
    listCashFlow = await DataHelper().selectCashFlow();
    DataHelper().close();
    _reverseList(); // Panggil method _reverseList untuk membalik urutan list
  }

  void _reverseList() {
    setState(() {
      listCashFlow = listCashFlow.reversed.toList();
    });
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.cashFlows.length,
      itemBuilder: (context, index) {
        CashFlow cashFlow = widget.cashFlows[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(
              '${cashFlow.description}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                Icon(
                  cashFlow.type == 1 ? Icons.arrow_upward : Icons.arrow_downward,
                  color: cashFlow.type == 1 ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  cashFlow.type == 1 ? 'Income' : 'Expense',
                  style: TextStyle(
                    color: cashFlow.type == 1 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Call the onEdit callback when edit button is pressed
                    widget.onEdit(cashFlow.id!);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Call the onDelete callback when delete button is pressed
                    widget.onDelete(cashFlow.id!);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
