import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/layout/cubit/cubit.dart';
import 'package:fristapp/layout/cubit/states.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GPCubit, GPStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GPCubit.get(context);
        var modeResponse;
        List<HRData> _chartData;
        TooltipBehavior _tooltipBehavior;

        _chartData = getChartData();
        _tooltipBehavior = TooltipBehavior(enable: true);
        // FlutterBlue flutterBlue = FlutterBlue.instance;
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 500.0,
                  width: double.infinity,
                  child: SfCartesianChart(
                    title: ChartTitle(text: 'Heart Rate'),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: _tooltipBehavior,
                    series: <ChartSeries>[
                      LineSeries<HRData, double>(
                          name: 'HR',
                          dataSource: _chartData,
                          xValueMapper: (HRData heartRate, _) => heartRate.year,
                          yValueMapper: (HRData heartRate, _) =>
                              heartRate.heartRate,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          enableTooltip: true)
                    ],
                    primaryXAxis: NumericAxis(
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                    ),
                    primaryYAxis: NumericAxis(
                      labelFormat: '{value} bpm',
                      // numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)
                    ),
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
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: RaisedButton(
                              child: Text('Predict'),
                              onPressed: () async {
                                modeResponse = await cubit.fetchModel(
                                    // 'http://127.0.0.1:5000/api?query=A'
                                    '10.0.2.2:5000/api?query=A');
                                // var decoded = jsonDecode(modeResponse);
                                // print(decoded['output']);
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
        );
      },
    );
  }

  List<HRData> getChartData() {
    final List<HRData> chartData = [
      HRData(5.5, 75),
      HRData(6, 82),
      HRData(7, 92),
      HRData(7.5, 100),
      HRData(8, 80)
    ];
    return chartData;
  }
}

class HRData {
  HRData(this.year, this.heartRate);
  final double year;
  final double heartRate;
}
