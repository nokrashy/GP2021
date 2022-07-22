import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/layout/cubit/cubit.dart';
import 'package:fristapp/layout/cubit/states.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../model/chart_data_model.dart';
import '../../shared/styles/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GPCubit, GPStates>(
      listener: (context, state) {
        if (state is ModelCycleSuccessState) {
          showToast(
              msg: "${state.val} mg/dL Added", state: toastStates.SUCCESS);
        }
      },
      builder: (context, state) {
        var cubit = GPCubit.get(context);
        TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
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
                            name: 'mg/dL',
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
                  SizedBox(
                    height: 8.0,
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        width: 160,
                        height: 60,
                        color: Color.fromARGB(255, 187, 224, 255),
                        child: Center(
                          child: Text(
                            'Blood Glucose\n${DateFormat.yMMMEd().format(cubit.startofTheDay).toString()}',
                            style: TextStyle(
                              fontSize: 19.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),

                  Container(
                    width: double.infinity,
                    child: new CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 20.0,
                      percent: 1.0,
                      center: new Text(
                        "${cubit.get_codition_text()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: cubit.get_codition_color(),
                        ),
                      ),
                      progressColor: cubit.get_codition_color(),
                    ),
                  ),

                  //
                  SizedBox(
                    height: 8.0,
                  ),
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green[200],
                                radius: 15,
                                child: Icon(
                                  IconBroken.Scan,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Current Glucose',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                cubit.getMinMaxGlucose()[2] == 0
                                    ? '--'
                                    : '${cubit.getMinMaxGlucose()[2].round()} mg/dL',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Glucose Statistics',
                                style: TextStyle(
                                  fontSize: 19.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 228, 153, 215),
                                radius: 15,
                                child: Icon(
                                  Icons.av_timer,
                                  color: Color.fromARGB(255, 211, 21, 179),
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Average',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                cubit.getMinMaxGlucose()[4] == 0
                                    ? '--'
                                    : '${cubit.getMinMaxGlucose()[4].round()} mg/dL',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.amber[200],
                                radius: 15,
                                child: Icon(
                                  IconBroken.Arrow___Up,
                                  color: Colors.amber[900],
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'largest',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                cubit.getMinMaxGlucose()[1] == 0
                                    ? '--'
                                    : '${cubit.getMinMaxGlucose()[1]} mg/dL',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue[100],
                                radius: 15,
                                child: Icon(
                                  IconBroken.Arrow___Down,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Lowest',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                cubit.getMinMaxGlucose()[0] == 1000
                                    ? '--'
                                    : '${cubit.getMinMaxGlucose()[0]} mg/dL',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Blood glucose is measured in  milligrams (mg) per decilitre (dL) (mg/dL).\n1.0 mmol/L = 18.02 mg/dL\nMaintaining a healthy level can decrease the risk of diabetes and heart disease.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
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
