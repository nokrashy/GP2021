import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/heart_rate/cubit/cubit.dart';
import 'package:fristapp/modules/vitals/heart_rate/cubit/states.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../../model/chart_data_model.dart';

class ActivityHR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HrCubit, HrStates>(
      listener: (context, state) {
        if (state is HrChangeTopNavBarState) {
          HrCubit.get(context).changetopNavBartoDay();
        }
      },
      builder: (context, state) {
        var cubit = HrCubit.get(context);
        late List<ChartData> _ChartData = cubit.getChartDatafcn();
        late TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
        List<Map<dynamic, dynamic>> snapshot = cubit.getrsponse();

        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 500,
                    child: SfCartesianChart(
                      legend: Legend(isVisible: true),
                      tooltipBehavior: _tooltipBehavior,
                      title: ChartTitle(
                          text:
                              '${cubit.selectedate.toString().substring(0, 10)}'),
                      series: <ChartSeries>[
                        ScatterSeries<ChartData, DateTime>(
                          name: 'Heart Rate',
                          dataSource: _ChartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                      primaryXAxis: DateTimeAxis(
                        minimum: cubit.getSelectedate(),
                        maximum: cubit.getSelectedate().add(Duration(days: 1)),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        dateFormat: DateFormat.H(),
                        intervalType: DateTimeIntervalType.hours,
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(labelFormat: '{value}'),
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.length,
                    itemBuilder: ((context, index) {
                      return Column(
                        children: [
                          Card(
                            child: ListTile(
                              title: Center(
                                  child: Text(
                                      '${double.parse(snapshot[index]['hrvalue']).round()}')),
                              leading: Text(
                                  '${snapshot[index]['hrdate'].toString().substring(10, 16)}'),
                              trailing: Text('Bpm'),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
