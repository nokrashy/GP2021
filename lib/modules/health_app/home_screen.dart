import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/layout/cubit/cubit.dart';
import 'package:fristapp/layout/cubit/states.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../model/chart_data_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GPCubit, GPStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GPCubit.get(context);
        TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
        var modeResponse;
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: cubit.fetchtodayglucose,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 500.0,
                    width: double.infinity,
                    child: SfCartesianChart(
                      title: ChartTitle(text: 'Blood Glucose'),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: _tooltipBehavior,
                      primaryXAxis: DateTimeAxis(
                          intervalType: DateTimeIntervalType.minutes),
                      series: <ChartSeries<ChartSampleData, DateTime>>[
                        LineSeries<ChartSampleData, DateTime>(
                            name: 'mmol/L',
                            dataSource: cubit.getChartData(),
                            xValueMapper: (ChartSampleData sales, _) =>
                                sales.time,
                            yValueMapper: (ChartSampleData sales, _) =>
                                sales.glucose,
                            dataLabelSettings:
                                DataLabelSettings(isVisible: false),
                            enableTooltip: true),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: new CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 20.0,
                      percent: 1.0,
                      center: new Text("100%"),
                      progressColor: Colors.green,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  MyDivider(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: RaisedButton(
                                child: Text('Predict'),
                                onPressed: () async {
                                  modeResponse = await cubit.fetchModel(
                                      'https://tessssssst.azurewebsites.net/'
                                      // '10.0.2.2:5000/api?query=A'
                                      );
                                  // var decoded = jsonDecode(modeResponse);
                                  print(modeResponse);
                                })),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(child: Text('Output:   ${0}')),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // List<GlucoseData> getChartData() {
  //   final List<GlucoseData> chartData = [
  //     GlucoseData(5.5, 75),
  //     GlucoseData(6, 82),
  //     GlucoseData(7, 92),
  //     GlucoseData(7.5, 100),
  //     GlucoseData(8, 80)
  //   ];
  //   return chartData;
  // }
}

// class GlucoseData {
//   GlucoseData(this.time, this.glucose);
//   final double time;
//   final double glucose;
// }
