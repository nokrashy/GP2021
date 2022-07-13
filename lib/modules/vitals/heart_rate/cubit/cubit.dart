import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/heart_rate/activity_hr.dart';
import 'package:fristapp/modules/vitals/heart_rate/cubit/states.dart';
import 'package:fristapp/modules/vitals/heart_rate/date_hr.dart';
import '../../../../model/chart_data_model.dart';
import '../../../../shared/network/local/sqldb.dart';

class HrCubit extends Cubit<HrStates> {
  HrCubit() : super(HrInitialState());

  static HrCubit get(context) => BlocProvider.of(context);
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
    emit(HrChangeTopNavBarState());
  }

  List<Widget> screenss = [
    DateHr(),
    ActivityHR(),
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
  int min_hr = 1000;
  int max_hr = 0;
  void setMinMaxHr({required int min, required int max}) {
    min_hr = min;
    max_hr = max;
  }

  List<int> getMinMaxHr() {
    return [min_hr, max_hr];
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
    int _min_hr = 1000;
    int _max_hr = 0;
    List<Map> _response = await _sqlDb.readData(
        "SELECT * FROM 'hrtable' WHERE `hrdate` > '${from}' AND `hrdate` < '${to}'");

    _response.forEach((element) {
      print(element['hrdate']);
      _getChartData.add(ChartData(DateTime.parse(element['hrdate']),
          double.parse('${element['hrvalue']}').round()));
      current_value = double.parse('${element['hrvalue']}').round();
      if (current_value > _max_hr) {
        _max_hr = current_value;
      }
      if (current_value < _min_hr) {
        _min_hr = current_value;
      }
    });
    setChartData(_getChartData);
    setMinMaxHr(min: _min_hr, max: _max_hr);
    setresponse(_response);
  }

  Future<void> changetopNavBartoDay() async {
    await readData(
        from: getSelectedate(), to: getSelectedate().add(Duration(days: 1)));
    emit(HrChangeTopNavBartoDaysState());
  }
}
