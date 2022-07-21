import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/carbohydrates/cubit/states.dart';
import 'package:fristapp/modules/vitals/carbohydrates/date_carbo.dart';
import 'package:health/health.dart';
import '../../../../model/chart_data_model.dart';
import '../../../../shared/network/local/sqldb.dart';
import '../activity_carbo.dart';

class CarboCubit extends Cubit<CarboStates> {
  CarboCubit() : super(CarboInitialState());

  static CarboCubit get(context) => BlocProvider.of(context);
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
    emit(CarboChangeTopNavBarState());
  }

  List<Widget> screenss = [
    DateCarbo(),
    ActivityCarbo(),
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
  int min_Carbo = 1000;
  int max_Carbo = 0;
  void setMinMaxCarbo({required int min, required int max}) {
    min_Carbo = min;
    max_Carbo = max;
  }

  List<int> getMinMaxCarbo() {
    return [min_Carbo, max_Carbo];
  }

//

//
  double sumcarbo = 0;
  double avgcarbo = 0;
  void setsumAndavgCarbo({required double sum, required double avg}) {
    sumcarbo = sum;
    avgcarbo = avg;
  }

  List<double> getsumAndavgCarbo() {
    return [sumcarbo, avgcarbo];
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
    int _min_Carbo = 1000;
    int _max_Carbo = 0;
    double _sumcarbo = 0;
    double _avgcarbo = 0;

    List<Map> _response = await _sqlDb.readData(
        "SELECT * FROM 'Carbohydratestable' WHERE `Carbohydratesdate` > '${from}' AND `Carbohydratesdate` < '${to}'");
    List<Map> new_response = [];

    for (int i = 0; i < 24; i++) {
      List<Map> _newresponse = await _sqlDb.readData(
          "SELECT `Carbohydratesvalue` FROM 'Carbohydratestable' WHERE `Carbohydratesdate` > '${from!.add(new Duration(hours: i))}' AND `Carbohydratesdate` < '${from.add(new Duration(hours: (i + 1)))}'");
      double sum = 0;
      _newresponse.forEach((element) {
        sum += double.parse(element['Carbohydratesvalue']);
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
      // print("Date ${element['Carbodate']}  => ${element['Carbovalue']}");

      print(element.keys.single.toString());

      _getChartData.add(ChartData(
          DateTime.parse(element.keys.single.toString()),
          double.parse(element.values.single.toString()).round()));
    });

    _response.forEach((element) {
      _sumcarbo = _sumcarbo + double.parse(element['Carbohydratesvalue']);

      current_value = double.parse('${element['Carbohydratesvalue']}').round();

      if (current_value > _max_Carbo) {
        _max_Carbo = current_value;
      }
      if (current_value < _min_Carbo) {
        _min_Carbo = current_value;
      }
    });
    if(_response.length == 0){
      _avgcarbo = 0;
    }else{
      _avgcarbo = (_sumcarbo / _response.length);
    }
    
    setsumAndavgCarbo(sum: _sumcarbo, avg: _avgcarbo);
    setChartData(_getChartData);
    setMinMaxCarbo(min: _min_Carbo, max: _max_Carbo);
    setresponse(_response);
  }

  Future<void> changetopNavBartoDay() async {
    await readData(
        from: getSelectedate(), to: getSelectedate().add(Duration(days: 1)));
    emit(CarboChangeTopNavBartoDaysState());
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
  addCarboToGooglefit({carbo,date})async{
    emit(CarboStartAddToGoogleFitSuccessState());
    bool _success =
        await health.writeHealthData(carbo!, HealthDataType.BODY_TEMPERATURE, date, date);
    if(_success){
      emit(CarboAddedToGoogleFitSuccessState());
    }else {
      emit(CarboAddedToGoogleFitErrorState());
    }
  }

}
