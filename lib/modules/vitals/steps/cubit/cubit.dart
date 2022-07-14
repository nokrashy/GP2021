import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/steps/cubit/states.dart';
import 'package:fristapp/modules/vitals/steps/date_steps.dart';
import 'package:fristapp/modules/vitals/steps/activity_steps.dart';
import '../../../../model/chart_data_model.dart';
import '../../../../shared/component/component.dart';
import '../../../../shared/network/local/sqldb.dart';

class StepsCubit extends Cubit<StepsStates> {
  StepsCubit() : super(StepsInitialState());

  static StepsCubit get(context) => BlocProvider.of(context);
  SqlDb _sqlDb = SqlDb();

  Future<void> changetopNavBartoDay() async {
    await readData(
        from: getSelectedate(), to: getSelectedate().add(Duration(days: 1)));
    emit(ChangeTopNavBartoDaysState());
  }

//
  List<ChartData> getChartData = [];
  void setChartData(List<ChartData> char_date) {
    getChartData = char_date;
  }

  List<ChartData> getChartDatafcn() {
    return getChartData;
  }

//
  int sumSteps = 0;
  int getsumSteps() {
    return sumSteps;
  }

  void setsumSteps(int steps) {
    sumSteps = steps;
  }

//
  List<Map> rsponse = [];
  List<Map> getrsponse() {
    return rsponse;
  }

  void setresponse(List<Map> res) {
    rsponse = res;
  }

//
  Future<void> readData({DateTime? from, DateTime? to}) async {
    List<ChartData> _getChartData = [];
    int _sumSteps = 0;
    List<Map> _response = await _sqlDb.readData(
        "SELECT * FROM 'stepstable' WHERE `stepsdate` > '${from}' AND `stepsdate` < '${to}'");
    List<Map> new_response = [];

    for (int i = 0; i < 24; i++) {
      List<Map> _newresponse = await _sqlDb.readData(
          "SELECT `stepsvalue` FROM 'stepstable' WHERE `stepsdate` > '${from!.add(new Duration(hours: i))}' AND `stepsdate` < '${from.add(new Duration(hours: (i + 1)))}'");
      double sum = 0;
      _newresponse.forEach((element) {
        sum += double.parse(element['stepsvalue']);
      });

      if (sum.isNaN) {
        new_response.add({'${from.add(new Duration(hours: (i + 1)))}': 0});
      } else {
        new_response
            .add({'${from.add(new Duration(hours: (i + 1)))}': sum.toInt()});
      }
    }
    new_response.forEach((element) {
      _getChartData.add(ChartData(
          DateTime.parse(element.keys.single.toString()),
          double.parse(element.values.single.toString()).round()));
    });

    //
    _response.forEach((element) {
      // _getChartData.add(ChartData(DateTime.parse(element['stepsdate']),
      //     int.parse(element['stepsvalue'])));
      _sumSteps = _sumSteps + int.parse(element['stepsvalue']);
    });
    setChartData(_getChartData);
    setsumSteps(_sumSteps);
    setresponse(_response);
  }

  DateTime selectedate = DateTime.now().subtract(Duration(days: 1));

  void setSelectedate(DateTime date) {
    selectedate = date;
  }

  DateTime getSelectedate() {
    return selectedate;
  }

  int tabIndex = 0;
  List<Tab> tabs = [
    Tab(
      text: 'Date',
    ),
    Tab(
      text: 'Activity',
    ),
  ];
  void changetopNavBar(int index) {
    tabIndex = index;
    emit(ChangeTopNavBarState());
  }

  List<Widget> screenss = [
    DateSteps(),
    ActivitySteps(),
  ];
}
