import 'package:flutter/material.dart';

import '../widget/custom_new_box_task_table.dart';

class NewBoxTaskRulePage extends StatefulWidget {
  const NewBoxTaskRulePage({super.key});

  @override
  State<NewBoxTaskRulePage> createState() => _NewBoxTaskRulePageState();
}

class _NewBoxTaskRulePageState extends State<NewBoxTaskRulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Box Task Rule'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: CustomTableLayout(
            radius: Radius.circular(12),
            titleColor: Color(0xFF61ADF4),
            borderSide: BorderSide(color: Color(0x6662AEF4), width: 1),
            cellHeight: 32,
            textStyle: TextStyle(fontSize: 12, color: Color(0xFF61ADF4)),
            titles: [Text('等级'), Text('奖励'), Text('瓜分奖池金额')],
            titleStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
            tableRows: [
              [Text('1'), Text('0.0')],
              [Text('2'), Text('0.0')],
              [Text('3'), Text('0.0')],
              [Text('4'), Text('0.0')],
              [Text('5'), Text('10.0')],
              [Text('6'), Text('10.0')],
              [Text('7'), Text('10.0')],
              [Text('8'), Text('20.0')],
              [Text('9'), Text('20.0')],
              [Text('10'), Text('50.0')],
              [Text('11'), Text('50.0')],
              [Text('12'), Text('50.0')],
              [Text('13'), Text('200.0')],
              [Text('14'), Text('200.0')],
              [Text('15'), Text('200.0')],
              [Text('16'), Text('200.0')],
              [Text('17'), Text('200.0')],
              [Text('18'), Text('200.0')],
              [Text('19'), Text('200.0')],
              [Text('20'), Text('500.0')],
            ],
            tailCells: [
              TailCell(begin: 1, end: 4, child: Text('2000.0')),
              TailCell(begin: 5, end: 9, child: Text('2000.0')),
              TailCell(begin: 10, end: 14, child: Text('2000.0')),
              TailCell(begin: 15, end: 19, child: Text('2000.0')),
              TailCell(begin: 20, end: 20, child: Text('3000.0')),
            ],
          ),
        ),
      ),
    );
  }
}
