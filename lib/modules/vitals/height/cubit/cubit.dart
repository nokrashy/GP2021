import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/height/cubit/states.dart';
import 'package:health/health.dart';

import '../../../../shared/network/local/sqldb.dart';

class HeightCubit extends Cubit<HeightStates> {
  HeightCubit() : super(HeightInitialState());

  static HeightCubit get(context) => BlocProvider.of(context);
  SqlDb _sqlDb = SqlDb();
  // Height and Height
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

  int min_Height = 1000;
  int max_Height = 0;
  void setMinMaxHeight({required int min, required int max}) {
    min_Height = min;
    max_Height = max;
  }

  List<int> getMinMaxHeight() {
    return [min_Height, max_Height];
  }

  // 

  Future<void> readData({DateTime? from, DateTime? to}) async {
    int current_value = 0;
    int _min_Height = 1000;
    int _max_Height = 0;
    List<Map> _response = await _sqlDb.readData(
        "SELECT * FROM 'heighttable' WHERE `heightdate` > '${from}' AND `heightdate` < '${to}'");

    _response.forEach((element) {
      current_value = double.parse('${element['heightvalue']}').round();

      if (current_value > _max_Height) {
        _max_Height = current_value;
      }
      if (current_value < _min_Height) {
        _min_Height = current_value;
      }
    });
    setMinMaxHeight(min: _min_Height, max: _max_Height);
    setresponse(_response);
    emit(HeightDataReadedFromSqlDB());
  }

  DateTime selectedate = DateTime.now().subtract(Duration(days: 7));
  void setSelectedate(DateTime date) {
    selectedate = date;
  }

  DateTime getSelectedate() {
    return selectedate;
  }

  HealthFactory health = HealthFactory();
  addHeightToGooglefit({Height, date}) async {
    bool _success = await health.writeHealthData(
        Height!, HealthDataType.HEIGHT, date, date);
    if (_success) {
      emit(HeightAddedToGoogleFitSuccessState());
    } else {
      emit(HeightAddedToGoogleFitErrorState());
    }
  }
}
