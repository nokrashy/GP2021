import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/Calories/activity_calori.dart';
import 'package:fristapp/modules/vitals/Calories/cubit/states.dart';
import 'package:fristapp/modules/vitals/Calories/date_calori.dart';
import '../../../../model/chart_data_model.dart';
import '../../../../shared/network/local/sqldb.dart';

class CaloriCubit extends Cubit<CaloriStates> {
  CaloriCubit() : super(CaloriInitialState());

  static CaloriCubit get(context) => BlocProvider.of(context);
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
  int sumCalori = 0;
  int getsumCalori() {
    return sumCalori;
  }

  void setsumCalori(int Calori) {
    sumCalori = Calori;
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
    int _sumCalori = 0;
    List<Map> _response = await _sqlDb.readData(
        "SELECT * FROM 'caloriestable' WHERE `caloriesdate` > '${from}' AND `caloriesdate` < '${to}'");
    List<Map> new_response = [];

    for (int i = 0; i < 24; i++) {
      List<Map> _newresponse = await _sqlDb.readData(
          "SELECT `caloriesvalue` FROM 'caloriestable' WHERE `caloriesdate` > '${from!.add(new Duration(hours: i))}' AND `caloriesdate` < '${from.add(new Duration(hours: (i + 1)))}'");
      double sum = 0;
      _newresponse.forEach((element) {
        sum += double.parse(element['caloriesvalue']);
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
      // _getChartData.add(ChartData(DateTime.parse(element['Caloridate']),
      //     int.parse(element['Calorivalue'])));
      _sumCalori = _sumCalori + int.parse(element['caloriesvalue']);
    });
    setChartData(_getChartData);
    setsumCalori(_sumCalori);
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
    DateCalori(),
    ActivityCalori(),
  ];
}
