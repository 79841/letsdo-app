import 'package:flutter/material.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/utils/space.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../provider/check_list.dart';
import '../provider/todo_list.dart';

class CheckListTodayChartStyle {
  static const double titleFontSize = 15.0;
  static const FontWeight titleFontWeight = FontWeight.w400;
  static const double normalFontSize = 15.0;
  static const FontWeight normalFontWeight = FontWeight.w600;
  static const double achievementFontSize = 18.0;
  static const FontWeight achievementFontWeight = FontWeight.w900;
}

class CheckListTodayChart extends StatefulWidget {
  final GlobalKey targetKey;
  final ScrollController controller;
  const CheckListTodayChart(
      {required this.targetKey, required this.controller, super.key});

  @override
  State<CheckListTodayChart> createState() => _CheckListTodayChartState();
}

class _CheckListTodayChartState extends State<CheckListTodayChart> {
  _scrollToTarget() {
    final targetPosition =
        widget.targetKey.currentContext!.findRenderObject() as RenderBox;
    final position = targetPosition.localToGlobal(Offset.zero);
    widget.controller.animateTo(
      position.dy,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

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
        // return _DonutChart(
        //   todoListCount: todoListCount,
        //   checkListCount: checkListCount,
        // );

        return Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                " 오늘의 달성도를 확인해 주세요",
                style: TextStyle(
                  fontSize: CheckListTodayChartStyle.titleFontSize,
                  fontWeight: CheckListTodayChartStyle.titleFontWeight,
                ),
              ),
            ),
            hspace(5.0),
            Container(
              // alignment: Alignment.center,
              // height: 200.0,

              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.50,
              decoration: const BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: _DonutChart(
                        todoListCount: todoListCount,
                        checkListCount: checkListCount,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "$todoListCount개의 할일 중\n$checkListCount개를 완료했어요.",
                              style: const TextStyle(
                                color: mainWhite,
                                fontSize:
                                    CheckListTodayChartStyle.normalFontSize,
                                fontWeight:
                                    CheckListTodayChartStyle.normalFontWeight,
                              ),
                            ),
                          ),
                          hspace(20.0),
                          FractionallySizedBox(
                            widthFactor: 0.7,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    const MaterialStatePropertyAll(mainBlue),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                              onPressed: _scrollToTarget,
                              child: const Text(
                                "할 일 확인하기",
                                style: TextStyle(
                                  color: mainBlack,
                                  fontSize:
                                      CheckListTodayChartStyle.normalFontSize,
                                  fontWeight:
                                      CheckListTodayChartStyle.normalFontWeight,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
      _ChartData('Completed', widget.checkListCount, mainWhite),
      _ChartData(
          'Not yet', widget.todoListCount - widget.checkListCount, mainGray),
    ];

    return SfCircularChart(
      legend: const Legend(
        isVisible: false,
      ),
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Container(
            child: Text(
              "${widget.checkListCount}/${widget.todoListCount}",
              style: const TextStyle(
                color: mainWhite,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
      series: <CircularSeries>[
        DoughnutSeries<_ChartData, String>(
          dataSource: data,
          innerRadius: "67%",
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
