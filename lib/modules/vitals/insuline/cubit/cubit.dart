import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/insuline/cubit/states.dart';
import 'package:health/health.dart';
import '../../../../model/chart_data_model.dart';
import '../../../../shared/network/local/sqldb.dart';
import '../activity_insuline.dart';
import '../date_insuline.dart';

class insulinCubit extends Cubit<insulinStates> {
  insulinCubit() : super(insulinInitialState());

  static insulinCubit get(context) => BlocProvider.of(context);
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
    emit(insulinChangeTopNavBarState());
  }

  List<Widget> screenss = [
    Dateinsulin(),
    Activityinsulin(),
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
  int min_insulin = 1000;
  int max_insulin = 0;
  void setMinMaxinsulin({required int min, required int max}) {
    min_insulin = min;
    max_insulin = max;
  }

  List<int> getMinMaxinsulin() {
    return [min_insulin, max_insulin];
  }

//

//
  double suminsulin = 0;
  double avginsulin = 0;
  void setsumAndavginsulin({required double sum, required double avg}) {
    suminsulin = sum;
    avginsulin = avg;
  }

  List<double> getsumAndavginsulin() {
    return [suminsulin, avginsulin];
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
    int _min_insulin = 1000;
    int _max_insulin = 0;
    double _suminsulin = 0;
    double _avginsulin = 0;

    List<Map> _response = await _sqlDb.readData(
        "SELECT * FROM 'Insulintable' WHERE `Insulindate` > '${from}' AND `Insulindate` < '${to}'");
    List<Map> new_response = [];
    print(_response);
    for (int i = 0; i < 24; i++) {
      List<Map> _newresponse = await _sqlDb.readData(
          "SELECT `Insulinvalue` FROM 'Insulintable' WHERE `Insulindate` > '${from!.add(new Duration(hours: i))}' AND `Insulindate` < '${from.add(new Duration(hours: (i + 1)))}'");
      double sum = 0;
      _newresponse.forEach((element) {
        sum += double.parse(element['Insulinvalue']);
      });

      if (sum.isNaN) {
        new_response.add({'${from.add(new Duration(hours: (i + 1)))}': 0});
      } else {
        new_response
            .add({'${from.add(new Duration(hours: (i + 1)))}': sum.toInt()});
      }
    }
    // print(new_response);

    new_response.forEach((element) {
      print('*********************************');
      print(element);
      // print("Date ${element['Insulindate']}  => ${element['Insulinvalue']}");

      // print(element.keys.single.toString());

      _getChartData.add(ChartData(
          DateTime.parse(element.keys.single.toString()),
          double.parse(element.values.single.toString()).round()));
    });

    _response.forEach((element) {
      // print("Date ${element['Insulindate']}  => ${element['Insulinvalue']}");

      _suminsulin = _suminsulin + double.parse(element['Insulinvalue']);

      current_value = double.parse('${element['Insulinvalue']}').round();

      if (current_value > _max_insulin) {
        _max_insulin = current_value;
      }
      if (current_value < _min_insulin) {
        _min_insulin = current_value;
      }
    });
    if (_response.length == 0) {
      _avginsulin = 0;
    } else {
      _avginsulin = (_suminsulin / _response.length);
    }

    setsumAndavginsulin(sum: _suminsulin, avg: _avginsulin);
    setChartData(_getChartData);
    setMinMaxinsulin(min: _min_insulin, max: _max_insulin);
    setresponse(_response);
  }

  Future<void> changetopNavBartoDay() async {
    await readData(
        from: getSelectedate(), to: getSelectedate().add(Duration(days: 1)));
    emit(insulinChangeTopNavBartoDaysState());
  }

  //

  // ***************************************

  //
  DateTime sselectedate = DateTime.now().subtract(Duration(days: 7));
  void ssetSelectedate(DateTime date) {
    sselectedate = date;
  }

  DateTime getsSelectedate() {
    return sselectedate;
  }

  HealthFactory health = HealthFactory();
  addinsulinToGooglefit({insulin, date}) async {
    emit(insulinStartAddToGoogleFitSuccessState());
    bool _success = await health.writeHealthData(
        insulin!, HealthDataType.BODY_FAT_PERCENTAGE, date, date);
    if (_success) {
      emit(insulinAddedToGoogleFitSuccessState());
    } else {
      emit(insulinAddedToGoogleFitErrorState());
    }
  }
}
