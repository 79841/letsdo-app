import 'package:flutter/material.dart';
import 'package:ksica/query/check_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

    DateTime startOfWeek = today.subtract(Duration(days: currentWeekday - 1));

    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    String startOfWeekStr = dateFormat.format(startOfWeek);
    String endOfWeekStr = dateFormat.format(endOfWeek);

    final List<String> daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"];

    return Consumer<CheckList>(
      builder: (_, __, ___) {
        return FutureBuilder(
          builder: (context, snapshot) {
            final List<DailyCheckList> checkListForWeek = [];

            daysOfWeek.asMap().forEach((i, e) {
              DateTime date = startOfWeek.add(Duration(days: i));
              String dateStr = dateFormat.format(date);
              checkListForWeek.add(DailyCheckList(e, dateStr, 0));
            });

            if (snapshot.hasData) {
              List<dynamic> checkList = snapshot.data!;
              print(checkList);
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
            return SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                maximum: maxYAxis,
                interval: 1,
                axisLabelFormatter: (axisLabel) {
                  if (axisLabel.value == maxYAxis) {
                    return ChartAxisLabel("", const TextStyle());
                  } else {
                    return ChartAxisLabel(
                        axisLabel.value.toString(), const TextStyle());
                  }
                },
              ),
              series: <ChartSeries>[
                LineSeries<DailyCheckList, String>(
                  dataSource: checkListForWeek,
                  xValueMapper: (DailyCheckList dcl, _) => dcl.day,
                  yValueMapper: (DailyCheckList dcl, _) {
                    if (DateTime.parse(dcl.date).difference(today).inDays > 0) {
                      return null;
                    }
                    return dcl.count;
                  },
                ),
                ScatterSeries<DailyCheckList, String>(
                  dataSource: checkListForWeek,
                  xValueMapper: (DailyCheckList dcl, _) => dcl.day,
                  yValueMapper: (DailyCheckList dcl, _) {
                    if (DateTime.parse(dcl.date).difference(today).inDays > 0) {
                      return null;
                    }
                    return dcl.count;
                  },
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                  ),
                ),
              ],
            );
          },
          future: fetchCheckListForPeriod(startOfWeekStr, endOfWeekStr),
        );
      },
    );
  }
}
