import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../provider/check_list.dart';
import '../provider/todo_list.dart';

class CheckListTodayChart extends StatefulWidget {
  const CheckListTodayChart({super.key});

  @override
  State<CheckListTodayChart> createState() => _CheckListTodayChartState();
}

class _CheckListTodayChartState extends State<CheckListTodayChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CheckList>(
      builder: (context, checkList, child) {
        int todoListCount =
            Provider.of<TodoList>(context, listen: false).todoList.length;

        int checkListCount = Provider.of<CheckList>(context, listen: false)
            .checkStates
            .where((e) => e["done"] == true)
            .length;

        return _DonutChart(
          todoListCount: todoListCount,
          checkListCount: checkListCount,
        );
      },
    );
  }
}

class _ChartData {
  final String label;
  final int value;
  final Color color;

  _ChartData(this.label, this.value, this.color);
}

class _DonutChart extends StatefulWidget {
  final int todoListCount;
  final int checkListCount;
  const _DonutChart(
      {required this.todoListCount, required this.checkListCount});

  @override
  State<_DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<_DonutChart> {
  @override
  Widget build(BuildContext context) {
    final List<_ChartData> data = [
      _ChartData('Completed', widget.checkListCount, Colors.black),
      _ChartData(
          'Not yet', widget.todoListCount - widget.checkListCount, Colors.grey),
    ];

    return SfCircularChart(
      legend: const Legend(
        isVisible: true,
      ),
      series: <CircularSeries>[
        PieSeries<_ChartData, String>(
          dataSource: data,
          xValueMapper: (_ChartData data, _) => data.label,
          yValueMapper: (_ChartData data, _) => data.value,
          // pointColorMapper: (_ChartData data, _) => data.color,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            // labelPosition: ChartDataLabelPosition.outside,
          ),
        ),
      ],
    );
  }
}
