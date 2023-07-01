import 'package:flutter/material.dart';
import 'package:ksica/provider/check_list.dart';
import 'package:ksica/query/check_list.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../query/todo_list.dart';

class CheckListChart extends StatefulWidget {
  const CheckListChart({super.key});

  @override
  State<CheckListChart> createState() => _CheckListChartState();
}

class _CheckListChartState extends State<CheckListChart> {
  Future<Map<String, int>> getDegreeOfCheckList() async {
    List<dynamic> todoList = await fetchTodoList();
    List<dynamic> checkList = await fetchCheckList();
    return {
      "todoListCount": todoList.length,
      "checkListCount": checkList.where((e) => e["done"] == true).length
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "오늘의 체크리스트 달성도",
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          Consumer<CheckList>(
            builder: (context, snapshot, child) {
              return FutureBuilder(
                future: getDegreeOfCheckList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _DonutChart(
                      todoListCount: snapshot.data?["todoListCount"] ?? 0,
                      checkListCount: snapshot.data?["checkListCount"] ?? 0,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Container(
                    width: 20.0,
                    height: 15.0,
                    margin: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                  const Text("Not yet"),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 20.0,
                    height: 15.0,
                    margin: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                  const Text("Completed"),
                ],
              ),
            ],
          ),
        ],
      ),
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
      series: <CircularSeries>[
        DoughnutSeries<_ChartData, String>(
          dataSource: data,
          xValueMapper: (_ChartData data, _) => data.label,
          yValueMapper: (_ChartData data, _) => data.value,
          pointColorMapper: (_ChartData data, _) => data.color,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            // labelPosition: ChartDataLabelPosition.outside,
          ),
        ),
      ],
    );
  }
}
