import 'package:flutter/material.dart';
import 'package:ksica/query/check_list.dart';
import 'package:intl/intl.dart';
import 'package:ksica/utils/space.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../config/style.dart';
import '../provider/check_list.dart';
import '../provider/todo_list.dart';

class CheckListWeekGraphStyle {
  static const double titleFontSize = 16.5;
  static const FontWeight titleFontWeight = FontWeight.w700;
  static const double iconSize = 20.0;
  static const double dayFontSize = 14.5;
  static const FontWeight dayFontWeight = FontWeight.w600;
}

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

    int currentWeekday = today.weekday % 7;

    DateTime startOfWeek = today.subtract(Duration(days: currentWeekday));

    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    String startOfWeekStr = dateFormat.format(startOfWeek);
    String endOfWeekStr = dateFormat.format(endOfWeek);

    final List<String> daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"];

    int todoListCount =
        Provider.of<TodoList>(context, listen: true).todoList.length;

    return Consumer<CheckList>(
      builder: (_, __, ___) {
        return FutureBuilder(
          future: fetchCheckListForPeriod(startOfWeekStr, endOfWeekStr),
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
                  Radius.circular(14.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "이번 주",
                              style: TextStyle(
                                color: mainBlack,
                                fontSize: CheckListWeekGraphStyle.titleFontSize,
                                fontWeight:
                                    CheckListWeekGraphStyle.titleFontWeight,
                              ),
                            ),
                          ),
                          wspace(10.0),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: mainBlack,
                            size: CheckListWeekGraphStyle.iconSize,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
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
                              child: _DayChart(
                                backgroundColor: bgColor,
                                checkListCount: e.value.count,
                                day: daysOfWeek[e.key],
                                textColor: textColor,
                                todoListCount: todoListCount,
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
        );
      },
    );
  }
}

class _DayChart extends StatelessWidget {
  final int todoListCount;
  final int checkListCount;
  final String day;
  final Color backgroundColor;
  final Color textColor;
  const _DayChart({
    required this.todoListCount,
    required this.checkListCount,
    required this.day,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: _DonutChart(
            todoListCount: todoListCount,
            checkListCount: checkListCount,
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
                color: backgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(11.0),
                ),
              ),
              child: Text(
                day,
                style: TextStyle(
                  color: textColor,
                  fontSize: CheckListWeekGraphStyle.dayFontSize,
                  fontWeight: CheckListWeekGraphStyle.dayFontWeight,
                ),
              ),
            ),
          ),
        ),
      ],
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
          'Not yet', widget.todoListCount - widget.checkListCount, lightGray),
    ];

    return SfCircularChart(
      legend: const Legend(
        isVisible: false,
      ),
      series: <CircularSeries>[
        DoughnutSeries<_ChartData, String>(
          dataSource: data,
          innerRadius: "50%",
          radius: "140%",
          xValueMapper: (_ChartData data, _) => data.label,
          yValueMapper: (_ChartData data, _) => data.value,
          pointColorMapper: (_ChartData data, _) => data.color,
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
        ),
      ],
    );
  }
}
