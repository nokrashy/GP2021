import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/weight/cubit/states.dart';
import 'package:health/health.dart';

import '../../../../shared/network/local/sqldb.dart';

class WeightCubit extends Cubit<WeightStates> {
  WeightCubit() : super(WeightInitialState());

  static WeightCubit get(context) => BlocProvider.of(context);
  SqlDb _sqlDb = SqlDb();
  // Weight and Height
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }

  List<Map> rsponse = [];
  List<Map> getrsponse() {
    return rsponse;
  }

  void setresponse(List<Map> res) {
    rsponse = res;
  }

  int min_Weight = 1000;
  int max_Weight = 0;
  void setMinMaxWeight({required int min, required int max}) {
    min_Weight = min;
    max_Weight = max;
  }

  List<int> getMinMaxWeight() {
    return [min_Weight, max_Weight];
  }

  Future<void> readData({DateTime? from, DateTime? to}) async {
    int current_value = 0;
    int _min_weight = 1000;
    int _max_weight = 0;
    List<Map> _response = await _sqlDb.readData(
        "SELECT * FROM 'weighttable' WHERE `weightsdate` > '${from}' AND `weightsdate` < '${to}'");

    _response.forEach((element) {
      current_value = double.parse('${element['weightvalue']}').round();

      if (current_value > _max_weight) {
        _max_weight = current_value;
      }
      if (current_value < _min_weight) {
        _min_weight = current_value;
      }
    });
    setMinMaxWeight(min: _min_weight, max: _max_weight);
    setresponse(_response);
    emit(WeightDataReadedFromSqlDB());
  }

  DateTime selectedate = DateTime.now().subtract(Duration(days: 7));
  void setSelectedate(DateTime date) {
    selectedate = date;
  }

  DateTime getSelectedate() {
    return selectedate;
  }
HealthFactory health = HealthFactory();
  addWeightToGooglefit({weight,date})async{
    bool _success =
        await health.writeHealthData(weight!, HealthDataType.WEIGHT, date, date);
    if(_success){
      emit(WeightAddedToGoogleFitSuccessState());
    }else {
      emit(WeighAddedToGoogleFitErrorState());
    }
  }
}
