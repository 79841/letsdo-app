import 'package:flutter/material.dart';
import 'package:ksica/query/check_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../config/style.dart';
import '../provider/check_list.dart';
import '../provider/todo_list.dart';

class DailyCheckList {
  final String day;
  final String date;
  int count;

  DailyCheckList(this.day, this.date, this.count);
}

class CheckListWeekGraph extends StatelessWidget {
  const CheckListWeekGraph({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day, 0, 0, 0);

    int currentWeekday = today.weekday;

    DateTime startOfWeek = today.subtract(Duration(days: currentWeekday));

    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    String startOfWeekStr = dateFormat.format(startOfWeek);
    String endOfWeekStr = dateFormat.format(endOfWeek);

    final List<String> daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"];

    int todoListCount =
        Provider.of<TodoList>(context, listen: false).todoList.length;

    return Consumer<CheckList>(
      builder: (_, __, ___) {
        return FutureBuilder(
          builder: (context, snapshot) {
            final List<DailyCheckList> checkListForWeek = [];

            daysOfWeek.asMap().forEach(
              (i, e) {
                DateTime date = startOfWeek.add(Duration(days: i));
                String dateStr = dateFormat.format(date);
                checkListForWeek.add(DailyCheckList(e, dateStr, 0));
              },
            );

            if (snapshot.hasData) {
              List<dynamic> checkList = snapshot.data!;
              for (var checkState in checkList) {
                int indexForDate = DateTime.parse(checkState["date"])
                    .difference(startOfWeek)
                    .inDays;
                if (checkState["done"] == true) {
                  checkListForWeek[indexForDate].count += 1;
                }
              }
            }

            double maxYAxis = Provider.of<TodoList>(context, listen: false)
                    .todoList
                    .length
                    .toDouble() +
                1;
            return Container(
              height: MediaQuery.of(context).size.width * 0.3,
              decoration: const BoxDecoration(
                color: mainWhite,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: const Text("이번주"),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: mainBlack,
                            size: 15.0,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: checkListForWeek.asMap().entries.map(
                          (e) {
                            Color textColor, bgColor;
                            if (e.value.date == dateFormat.format(today)) {
                              textColor = mainWhite;
                              bgColor = mainBlack;
                            } else {
                              textColor = mainBlack;
                              bgColor = Colors.transparent;
                            }
                            if (daysOfWeek[e.key] == "일") {
                              textColor = Colors.red;
                            } else if (daysOfWeek[e.key] == "토") {
                              textColor = darkBlue;
                            }
                            return Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _DonutChart(
                                      todoListCount: todoListCount,
                                      checkListCount: e.value.count,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        alignment: Alignment.topCenter,
                                        height: 22.0,
                                        width: 22.0,
                                        decoration: BoxDecoration(
                                          color: bgColor,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(11.0),
                                          ),
                                        ),
                                        child: Text(
                                          daysOfWeek[e.key],
                                          style: TextStyle(
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   child: const Text("a"),
                                  // )
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          future: fetchCheckListForPeriod(startOfWeekStr, endOfWeekStr),
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
      _ChartData('Completed', widget.checkListCount, darkBlue),
      _ChartData(
          'Not yet', widget.todoListCount - widget.checkListCount, mainGray),
    ];

    return SfCircularChart(
      legend: const Legend(
        isVisible: false,
      ),
      series: <CircularSeries>[
        DoughnutSeries<_ChartData, String>(
          dataSource: data,
          innerRadius: "55%",
          radius: "135%",
          xValueMapper: (_ChartData data, _) => data.label,
          yValueMapper: (_ChartData data, _) => data.value,
          pointColorMapper: (_ChartData data, _) => data.color,
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
            // labelPosition: ChartDataLabelPosition.outside,
          ),
        ),
      ],
    );
  }
}
