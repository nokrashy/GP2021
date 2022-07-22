import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/blood_glucose/activity_glucose.dart';
import 'package:fristapp/modules/vitals/blood_glucose/cubit/states.dart';
import 'package:fristapp/modules/vitals/blood_glucose/date_glucose.dart';
import 'package:health/health.dart';

import '../../../../model/chart_data_model.dart';
import '../../../../shared/network/local/sqldb.dart';

class GlucoseCubit extends Cubit<GlucoseStates> {
  GlucoseCubit() : super(GlucoseInitialState());

  static GlucoseCubit get(context) => BlocProvider.of(context);
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
    emit(GlucoseChangeTopNavBarState());
  }

  List<Widget> screenss = [
    DateGlucose(),
    ActivityGlucose(),
  ];

//
  List<ChartData> getChartData = [];
  void setChartData(List<ChartData> char_date) {
    getChartData = char_date;
  }

  List<ChartData> getChartDatafcn() {
    return getChartData;
  }

//
  int min_Glucose = 1000;
  int max_Glucose = 0;
  void setMinMaxGlucose({required int min, required int max}) {
    min_Glucose = min;
    max_Glucose = max;
  }

  List<int> getMinMaxGlucose() {
    return [min_Glucose, max_Glucose];
  }

//
  DateTime selectedate = DateTime.now().subtract(Duration(days: 1));

  void setSelectedate(DateTime date) {
    selectedate = date;
  }

  DateTime getSelectedate() {
    return selectedate;
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
  SqlDb _sqlDb = SqlDb();

  Future<void> readData({DateTime? from, DateTime? to}) async {
    List<ChartData> _getChartData = [];
    int current_value = 0;
    int _min_Glucose = 1000;
    int _max_Glucose = 0;
    List<Map> _response = await _sqlDb.readData(
        "SELECT * FROM 'Glucosetable' WHERE `Glucosedate` > '${from}' AND `Glucosedate` < '${to}'");
    List<Map> new_response = [];

    for (int i = 0; i < 24; i++) {
      List<Map> _newresponse = await _sqlDb.readData(
          "SELECT `Glucosevalue` FROM 'Glucosetable' WHERE `Glucosedate` > '${from!.add(new Duration(hours: i))}' AND `Glucosedate` < '${from.add(new Duration(hours: (i + 1)))}'");
      double sum = 0;
      _newresponse.forEach((element) {
        sum += double.parse(element['Glucosevalue']);
      });

      if ((sum / _newresponse.length).isNaN) {
        new_response.add({'${from.add(new Duration(hours: (i + 1)))}': 0});
      } else {
        new_response.add({
          '${from.add(new Duration(hours: (i + 1)))}':
              (sum ~/ _newresponse.length).toInt()
        });
      }
    }

    new_response.forEach((element) {
      _getChartData.add(ChartData(
          DateTime.parse(element.keys.single.toString()),
          double.parse(element.values.single.toString()).round()));
    });

    _response.forEach((element) {
      current_value = double.parse('${element['Glucosevalue']}').round();

      if (current_value > _max_Glucose) {
        _max_Glucose = current_value;
      }
      if (current_value < _min_Glucose) {
        _min_Glucose = current_value;
      }
    });
    setChartData(_getChartData);
    setMinMaxGlucose(min: _min_Glucose, max: _max_Glucose);
    setresponse(_response);
  }

  Future<void> changetopNavBartoDay() async {
    await readData(
        from: getSelectedate(), to: getSelectedate().add(Duration(days: 1)));
    emit(GlucoseChangeTopNavBartoDaysState());
  }

  //
  DateTime sselectedate = DateTime.now().subtract(Duration(days: 7));
  void ssetSelectedate(DateTime date) {
    sselectedate = date;
  }

  DateTime getsSelectedate() {
    return sselectedate;
  }

  HealthFactory health = HealthFactory();
  addglucoseToGooglefit({glucose, date}) async {
    emit(GlucoseStartAddToGoogleFitSuccessState());
    bool _success = await health.writeHealthData(
        glucose!, HealthDataType.BLOOD_GLUCOSE, date, date);
    if (_success) {
      emit(GlucoseAddedToGoogleFitSuccessState());
    } else {
      emit(GlucoseAddedToGoogleFitErrorState());
    }
  }
}
