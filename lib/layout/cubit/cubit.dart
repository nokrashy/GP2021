import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fristapp/layout/cubit/states.dart';
import 'package:fristapp/model/user_model.dart';
import 'package:fristapp/modules/health_app/home_screen.dart';
import 'package:fristapp/modules/health_app/info_screen.dart';
import 'package:fristapp/modules/health_app/settings_screen.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:fristapp/shared/component/constants.dart';
import 'package:fristapp/shared/network/local/cache_helper.dart';
import 'package:fristapp/shared/network/local/sqldb.dart';
import 'package:fristapp/shared/styles/icon_broken.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import '../../model/chart_data_model.dart';
import '../../modules/Firebase/firebase.dart';
import '../../modules/vitals/blood_glucose/cubit/cubit.dart';
import 'Constant/google_fit_functions.dart';

class GPCubit extends Cubit<GPStates> {
  GPCubit() : super(InitialState());
  static GPCubit get(context) => BlocProvider.of(context);

  // ******************************      Main App Construction      ******************************
  int currentIndex = 0;
  List<String> appBartitle = ['Glucose tracking', 'Vitals', 'Settings'];
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.health_and_safety_outlined,
        ),
        label: 'Home'),
    BottomNavigationBarItem(
      icon: Icon(
        IconBroken.Info_Square,
      ),
      label: 'Info',
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Setting),
      label: 'Settings',
    ),
  ];
  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(BottomNavState());
  }

  List<Widget> screens = [
    HomeScreen(),
    Infoscreen(),
    Settingsscreen(),
  ];
  bool IsDark = false;
  void ChangeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      IsDark = fromShared;
    } else
      IsDark = !IsDark;
    CachHelper.saveData(key: 'isDark', value: IsDark).then((value) {
      emit(AppChangeModeState());
    });
  }

// ******************************      Firebase      ******************************
  UserModel? usermodel;
  void getUserData() {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('Users').doc(uId).get().then((value) {
      usermodel = UserModel.fromJson(value.data());
      doc_num = usermodel!.phone;
      emit(GetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserErrorState(error.toString()));
    });
  }

  void UserDeleteAccount() {
    emit(UserDeleteAccountLoadingState());
    FirebaseAuth.instance.currentUser!.delete().then((value) async {
      SqlDb _sqlDb = SqlDb();
      await _sqlDb.mydeleteDatabase();
      print('Deleted Successfully');
      emit(UserDeleteAccountSuccessState());
    }).catchError((error) {
      UserDeleteAccountErrorState(error.toString());
      print(error.toString());
    });
  }

// ******************************      Google Fit      ******************************
  HealthFactory health = HealthFactory();
  List<HealthDataPoint> healthDataList = [];

// Request Connect to google fit
  bool AuthorizationRequested = false;
  bool isConnected = false;
  void getisConnected({bool? fromShared}) {
    if (fromShared != false) {
      isConnected = true;
      emit(IsConnectedSTrueState());
    } else
      isConnected = false;
    CachHelper.saveData(key: 'isConnected', value: isConnected).then((value) {
      emit(IsConnectedFalseState());
    });
    // if (isConnected == true) {
    //   modelCycleOn();
    // } else {
    //   modelCycleOff();
    // }
  }

  //

  Future revoke() async {
    await HealthFactory.revokePermissions().then((value) {
      print('Revoked Successfully');
    }).catchError((onError) {
      print('Error: ${onError}');
    });
  }

  Future Request_Connect() async {
    emit(StartConnecttoFitState());
    final types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BODY_FAT_PERCENTAGE,
      HealthDataType.BODY_TEMPERATURE,
    ];
    final rights = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];
    final permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
    ];
    bool? hasPermissions =
        await HealthFactory.hasPermissions(types, permissions: rights);
    if (hasPermissions == false) {
      AuthorizationRequested =
          await health.requestAuthorization(types, permissions: rights);
      AuthorizationRequested =
          await health.requestAuthorization(types, permissions: permissions);
    }
    if (AuthorizationRequested) {
      isConnected = true;
      CachHelper.saveData(key: 'isConnected', value: isConnected).then((value) {
        emit(ConnecttoFitSuccessState());
      });
    } else {
      emit(ConnecttoFitFailedsState());
    }
  }

  // Add some random health data.
  double? _mgdl;
  double? _hr;
  double? _steps;
  double? _calories;
  double? _weight;
  double? _height;
  double? _fat_insuline;
  double? _temperatur_carbohydrates;

  Future addData() async {
    final now = DateTime.now();
    final earlier = now.subtract(Duration(minutes: 5));
    _mgdl = Random().nextInt(80) + 50;
    _hr = Random().nextInt(50) + 60;
    _steps = Random().nextInt(250) + 0;
    _calories = Random().nextInt(10) + 17;
    _weight = Random().nextInt(50) + 50;
    _height = Random().nextInt(100) + 100;
    _fat_insuline = Random().nextInt(99) + 1;
    _temperatur_carbohydrates = Random().nextInt(100) + 20;

    bool _success1 = await health.writeHealthData(
        _mgdl!, HealthDataType.BLOOD_GLUCOSE, now, now);
    bool _success2 = await health.writeHealthData(
        _steps!.toDouble(), HealthDataType.STEPS, earlier, now);
    bool _success3 =
        await health.writeHealthData(_hr!, HealthDataType.HEART_RATE, now, now);
    bool _success4 = await health.writeHealthData(_calories!.toDouble(),
        HealthDataType.ACTIVE_ENERGY_BURNED, earlier, now);
    bool _success5 =
        await health.writeHealthData(_weight!, HealthDataType.WEIGHT, now, now);
    bool _success6 = await health.writeHealthData(
        (_height! * 0.01), HealthDataType.HEIGHT, now, now);
    bool _success7 = await health.writeHealthData(
        _fat_insuline!, HealthDataType.BODY_FAT_PERCENTAGE, now, now);
    bool _success8 = await health.writeHealthData(
        _temperatur_carbohydrates!, HealthDataType.BODY_TEMPERATURE, now, now);

    if (_success1 &&
        _success2 &&
        _success3 &&
        _success4 &&
        _success5 &&
        _success6 &&
        _success7 &&
        _success8) {
      emit(DataAddedToGoogleFitSuccessState());
    } else {
      emit(DataAddedToGoogleFitErrorState());
    }
  }

  // ------------------------------------------------------
  final lastmonth = DateTime.now().subtract(Duration(days: 10));

  Future<void> refreshandfetch() =>
      Future.delayed(Duration(seconds: 2), () async {
        print('*************************************************************');
        SqlDb _sqlDb = SqlDb();
        DateTime fetch_steps_from_date;
        DateTime fetch_hr_from_date;
        DateTime fetch_calories_from_date;
        DateTime fetch_weight_from_date;
        DateTime fetch_height_from_date;
        DateTime fetch_glucose_from_date;
        DateTime fetch_fat_insuline;
        DateTime fetch_temperatur_carbohydrates;

        List<Map> last_date_in_steps_db = await _sqlDb.readData(
            "SELECT `stepsdate` FROM 'stepstable' ORDER BY `id` DESC LIMIT 1");
        List<Map> last_date_in_hr_db = await _sqlDb.readData(
            "SELECT `hrdate` FROM 'hrtable' ORDER BY `id` DESC LIMIT 1");
        List<Map> last_date_in_calories_db = await _sqlDb.readData(
            "SELECT `caloriesdate` FROM 'caloriestable' ORDER BY `id` DESC LIMIT 1");

        List<Map> last_date_in_weight_db = await _sqlDb.readData(
            "SELECT `weightsdate` FROM 'weighttable' ORDER BY `id` DESC LIMIT 1");
        List<Map> last_date_in_height_db = await _sqlDb.readData(
            "SELECT `heightdate` FROM 'heighttable' ORDER BY `id` DESC LIMIT 1");
        List<Map> last_date_in_glucose_db = await _sqlDb.readData(
            "SELECT `Glucosedate` FROM 'Glucosetable' ORDER BY `id` DESC LIMIT 1");

        List<Map> last_date_in_Insulin_db = await _sqlDb.readData(
            "SELECT `Insulindate` FROM 'Insulintable' ORDER BY `id` DESC LIMIT 1");
        List<Map> last_date_in_Carbohydrates_db = await _sqlDb.readData(
            "SELECT `Carbohydratesdate` FROM 'Carbohydratestable' ORDER BY `id` DESC LIMIT 1");

        if (last_date_in_steps_db.isEmpty) {
          print('last_date_in_steps_db is Empty');
          fetch_steps_from_date = lastmonth;
        } else {
          fetch_steps_from_date = DateTime.parse(
              '${last_date_in_steps_db[0].values.toString().substring(1, 23)}');
          print(last_date_in_steps_db);
        }
        if (last_date_in_hr_db.isEmpty) {
          print('last_date_in_hr_db is Empty');
          fetch_hr_from_date = lastmonth;
        } else {
          fetch_hr_from_date = DateTime.parse(
                  '${last_date_in_hr_db[0].values.toString().substring(1, 23)}')
              .add(Duration(seconds: 2));
        }

        if (last_date_in_calories_db.isEmpty) {
          print('last_date_in_calories_db is Empty');
          fetch_calories_from_date = lastmonth;
        } else {
          fetch_calories_from_date = DateTime.parse(
                  '${last_date_in_calories_db[0].values.toString().substring(1, 23)}')
              .add(Duration(seconds: 2));
        }

        if (last_date_in_weight_db.isEmpty) {
          print('last_date_in_weight_db is Empty');
          fetch_weight_from_date = lastmonth;
        } else {
          fetch_weight_from_date = DateTime.parse(
                  '${last_date_in_weight_db[0].values.toString().substring(1, 23)}')
              .add(Duration(seconds: 2));
        }

        if (last_date_in_height_db.isEmpty) {
          print('last_date_in_height_db is Empty');
          fetch_height_from_date = lastmonth;
        } else {
          fetch_height_from_date = DateTime.parse(
                  '${last_date_in_height_db[0].values.toString().substring(1, 23)}')
              .add(Duration(seconds: 2));
        }

        if (last_date_in_glucose_db.isEmpty) {
          print('last_date_in_glucose_db is Empty');
          fetch_glucose_from_date = lastmonth;
        } else {
          fetch_glucose_from_date = DateTime.parse(
                  '${last_date_in_glucose_db[0].values.toString().substring(1, 23)}')
              .add(Duration(seconds: 2));
        }

        if (last_date_in_Insulin_db.isEmpty) {
          print('last_date_in_Insulin_db is Empty');
          fetch_fat_insuline = lastmonth;
        } else {
          fetch_fat_insuline = DateTime.parse(
                  '${last_date_in_Insulin_db[0].values.toString().substring(1, 23)}')
              .add(Duration(seconds: 2));
        }

        if (last_date_in_Carbohydrates_db.isEmpty) {
          print('last_date_in_Carbohydrates_db is Empty');
          fetch_temperatur_carbohydrates = lastmonth;
        } else {
          fetch_temperatur_carbohydrates = DateTime.parse(
                  '${last_date_in_Carbohydrates_db[0].values.toString().substring(1, 23)}')
              .add(Duration(seconds: 2));
        }

        if (isConnected) {
          // Fetch Steps from google fit and insert it in stepstable in the sql database
          List<HealthDataPoint> _steps = await ConstantFunctinsCubit()
              .fetchSteps(from: fetch_steps_from_date, to: DateTime.now());

          _steps.forEach((element) async {
            int steps_response = await _sqlDb.insertData(
                "INSERT INTO `stepstable` ( `stepsdate`, `stepsvalue`) VALUES ( '${element.dateTo}' , ${element.value} )");
            print('Insert Step value in index Number ${steps_response}');
          });

          // Fetch Heart rate from google fit and insert it in stepstable in the sql database

          List<HealthDataPoint> _hr = await ConstantFunctinsCubit()
              .fetchHeartRate(from: fetch_hr_from_date, to: DateTime.now());
          _hr.forEach((element) async {
            int hr_response = await _sqlDb.insertData(
                "INSERT INTO `hrtable` ( `hrdate`, `hrvalue` ) VALUES ( '${element.dateTo}' , ${element.value})");
            print('Insert Hr value in index Number ${hr_response}');
          });
          // Fetch Calories from google fit and insert it in stepstable in the sql database
          List<HealthDataPoint> _calories = await ConstantFunctinsCubit()
              .fetchCalories(
                  from: fetch_calories_from_date, to: DateTime.now());
          _calories.forEach((element) async {
            // print(element.dateFrom);
            // print(element.dateTo);
            // print(element.value.round());
            if (element.value.round() > 1) {
              int calories_response = await _sqlDb.insertData(
                  // "INSERT INTO `caloriestable` (`caloriesdate`,`caloriesvalue` ,`untillcaloriesdate`) VALUES ( '${int.parse(element.dateFrom.toString())}' , ${element.value} , ${element.dateTo} )");
                  ''' INSERT INTO `caloriestable` 
              (`caloriesdate`,`caloriesvalue`, `untillcaloriesdate`) 
              VALUES 
              ( '${element.dateTo}' ,'${element.value.round()}','${element.dateTo}')
              ''');

              print(
                  'Insert calories value in index Number ${calories_response}');
            }
          });

          // Fetch Weight from google fit and insert it in weighttable in the sql database
          List<HealthDataPoint> _weightList = await ConstantFunctinsCubit()
              .fetchWeight(from: fetch_weight_from_date, to: DateTime.now());
          _weightList.forEach((element) async {
            int weight_response = await _sqlDb.insertData(
                "INSERT INTO `weighttable` ( `weightsdate`, `weightvalue` ) VALUES ( '${element.dateTo}' , ${element.value})");
            print('Insert Weight value in index Number ${weight_response}');
          });

          // Fetch Height from google fit and insert it in heighttable in the sql database
          List<HealthDataPoint> _heightList = await ConstantFunctinsCubit()
              .fetchHeight(from: fetch_height_from_date, to: DateTime.now());
          _heightList.forEach((element) async {
            int height_response = await _sqlDb.insertData(
                "INSERT INTO `heighttable` ( `heightdate`, `heightvalue` ) VALUES ( '${element.dateTo}' , ${element.value})");
            print('Insert Height value in index Number ${height_response}');
          });

          // Fetch Glucose from google fit and insert it in Glucosetable in the sql database
          List<HealthDataPoint> _glucoseList = await ConstantFunctinsCubit()
              .fetchBloodGlucose(
                  from: fetch_glucose_from_date, to: DateTime.now());

          _glucoseList.forEach((element) async {
            print(element);

            int glucose_response = await _sqlDb.insertData(
                "INSERT INTO `Glucosetable` ( `Glucosedate`, `Glucosevalue` ) VALUES ( '${element.dateTo}' , ${element.value})");
            print('Insert Glucose value in index Number ${glucose_response}');
          });

          // Fetch fat_insuline from google fit and insert it in Glucosetable in the sql database
          List<HealthDataPoint> _insulineList = await ConstantFunctinsCubit()
              .fetchFatInsuline(from: fetch_fat_insuline, to: DateTime.now());
          _insulineList.forEach((element) async {
            print(element);
            int insuline_response = await _sqlDb.insertData(
                "INSERT INTO `Insulintable` ( `Insulindate`, `Insulinvalue` ) VALUES ( '${element.dateTo}' , ${element.value})");
            print('Insert Insuline value in index Number ${insuline_response}');
          });

          // Fetch  Temperatur_carbohydrates from google fit and insert it in Glucosetable in the sql database

          List<HealthDataPoint> _carbohydratesList =
              await ConstantFunctinsCubit().fetchTemperaturCarbohydrates(
                  from: fetch_temperatur_carbohydrates, to: DateTime.now());
          _carbohydratesList.forEach((element) async {
            print(element);
            int carbohydrates_response = await _sqlDb.insertData(
                "INSERT INTO `Carbohydratestable` ( `Carbohydratesdate`, `Carbohydratesvalue` ) VALUES ( '${element.dateTo}' , ${element.value})");
            print(
                'Insert Carbohydrates value in index Number ${carbohydrates_response}');
          });
          emit(RefreshAndFetchDataState());
        }
      });
// -----------------------------------------------------------------------------------------------------------
// ***********************************Settings Screen *************************
  Future<AuthStatus> resetPassword(
      {required String email, required BuildContext context}) async {
    emit(ResetLoadingState());
    late AuthStatus _status;
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      _status = AuthStatus.successful;
      Navigator.pop(context);
      emit(ResetSuccessState());
    }).catchError((e) {
      _status = AuthExceptionHandler.handleAuthException(e);
      emit(ResetErrorState());
    });
    return _status;
  }
  // ********************************************************************

// Handle Phone Number
  bool isupdated = false;
  late String doc_num;
  void edite_number(String newNum, BuildContext context) {
    try {
      int checknum = int.parse(newNum);
      if ((newNum.length == 11) && (newNum.substring(0, 2) == '01')) {
        doc_num = newNum;
        isupdated = true;
        showToast(
            msg: 'Phone Number Edited Successfully',
            state: toastStates.SUCCESS);
        Navigator.pop(context);
        emit(HandlePhoneNumberSuccessState());
      } else {
        // Enter valid phone number
        showToast(msg: 'Enter a valid number', state: toastStates.WARNING);

        emit(HandlePhoneNumbererrorState());
      }
    } catch (error) {
      print('error :  ${error}');
      // Enter valid phone number
      showToast(msg: 'Enter a valid number', state: toastStates.WARNING);
      emit(HandlePhoneNumbererrorState());
    }
  }

  //***************************************/ Handle Model ****************************
  //
  Future<String> predictPrice(
      {required String url,
      required double calories,
      required double hr,
      required double steps,
      required double glucose,
      required double insuline,
      required double carbo}) async {
    var body = [
      {
        "Calories": calories,
        "Average heart rate ": hr,
        "Step count": steps,
        "Historic Glucose": glucose,
        "Rapid-Acting Insulin": insuline,
        "Carbohydrates": carbo,
      }
    ];
    var client = new http.Client();
    var uri = Uri.parse(url);
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonString = json.encode(body);
    try {
      emit(MOdelLoadingState());
      var resp = await client.post(uri, headers: headers, body: jsonString);
      if (resp.statusCode == 200) {
        print("DATA FETCHED SUCCESSFULLY");
        var result = json.decode(resp.body);
        print(result["prediction"]);
        emit(MOdelrSuccessState());
        return result["prediction"];
      }
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      emit(MOdelErrorState());
      return 'f';
    }
    return 'fff';
  }

  ////************************************** */ Background Cycle ****************************

  bool isOn = false;
  int alarmId = 1;
  void ChangeisOn({bool? fromShared}) {
    if (fromShared != null) {
      isOn = fromShared;
    } else
      isOn = !isOn;
    CachHelper.saveData(key: 'isOn', value: isOn).then((value) {
      emit(ChangeisOnState());
    });
    if (isOn == true) {
      modelCycleOn();
    } else {
      modelCycleOff();
    }
  }

  Timer? timer;
  void modelCycleOn() {
    const oneSec = Duration(minutes: 15);
    timer = Timer.periodic(oneSec, (Timer t) {
      refreshandfetch().then((value) {
        getLast15().then((value) {
          predictPrice(
            url: 'https://tessssssst.azurewebsites.net//Mypredict',
            calories: calories_sum,
            hr: hr_avg,
            steps: steps_sum,
            glucose: glucose_avg,
            insuline: insuline_sum,
            carbo: carbo_sum,
          ).then((value) {
            print('Result : ${value}');
            addglucoseToGooglefit(
              glucose: double.parse(value),
              date: DateTime.now(),
            );
            refreshandfetch();
            emit(ModelCycleSuccessState(value));
          }).catchError((onError) {
            print('Error: ${onError}');
            emit(ModelCycleErrorState());
          });
        }).catchError((onError) {
          print('Error: ${onError}');
          emit(GetLast15ErrorState());
        });
      });

      // addData();
    });
  }

  void modelCycleOff() {
    if (timer != null) {
      timer?.cancel();
      print('Timer Turned OFF');
    }

    emit(ModelCycleOFFState());
  }

  // ****Functions related to model cycle****
  double hr_avg = 0;
  double glucose_avg = 0;
  double calories_sum = 0;
  double steps_sum = 0;
  double insuline_sum = 0;
  double carbo_sum = 0;
  void setlast15({
    required double hr_avgg,
    required double glucose_avgg,
    required double calories_sumg,
    required double steps_sumg,
    required double insuline_sumg,
    required double carbo_sumg,
  }) {
    hr_avg = hr_avgg;
    glucose_avg = glucose_avgg;
    calories_sum = calories_sumg;
    steps_sum = steps_sumg;
    insuline_sum = insuline_sumg;
    carbo_sum = carbo_sumg;
  }

  Future<void> getLast15() async {
    DateTime befor_fifteen_minutes =
        DateTime.now().subtract(Duration(minutes: 15));
    DateTime Noww = DateTime.now();
    double _hr_avg = 0;
    double _glucose_avg = 0;
    double _calories_sum = 0;
    double _hr_sum = 0;
    double _steps_sum = 0;
    double _glucose_sum = 0;
    double _insuline_sum = 0;
    double _carbo_sum = 0;
    setlast15(
      calories_sumg: _calories_sum,
      carbo_sumg: _carbo_sum,
      glucose_avgg: _glucose_avg,
      hr_avgg: _hr_avg,
      insuline_sumg: _insuline_sum,
      steps_sumg: _steps_sum,
    );
    List<Map> _calories_response = await _sqlDb.readData(
        "SELECT `caloriesvalue` FROM 'caloriestable' WHERE `caloriesdate` > '${befor_fifteen_minutes}' AND `caloriesdate` < '${Noww}'");
    _calories_response.forEach((element) {
      _calories_sum += double.parse(element['caloriesvalue']);
    });

    List<Map> _hr_response = await _sqlDb.readData(
        "SELECT `hrvalue` FROM 'hrtable' WHERE `hrdate` > '${befor_fifteen_minutes}' AND `hrdate` < '${Noww}'");
    _hr_response.forEach((element) {
      _hr_sum += double.parse(element['hrvalue']);
    });
    sleep(new Duration(milliseconds: 10));
    List<Map> _steps_response = await _sqlDb.readData(
        "SELECT `stepsvalue` FROM 'stepstable' WHERE `stepsdate` > '${befor_fifteen_minutes}' AND `stepsdate` < '${Noww}'");
    _steps_response.forEach((element) {
      _steps_sum += double.parse(element['stepsvalue']);
    });

    List<Map> _glucose_response = await _sqlDb.readData(
        "SELECT `Glucosevalue` FROM 'Glucosetable' WHERE `Glucosedate` > '${befor_fifteen_minutes}' AND `Glucosedate` < '${Noww}'");
    _glucose_response.forEach((element) {
      _glucose_sum += double.parse(element['Glucosevalue']);
    });
    sleep(new Duration(milliseconds: 10));
    List<Map> _insuline_response = await _sqlDb.readData(
        "SELECT  `Insulinvalue` FROM 'Insulintable' WHERE `Insulindate` > '${befor_fifteen_minutes}' AND `Insulindate` < '${Noww}'");
    _insuline_response.forEach((element) {
      _insuline_sum += double.parse(element['Insulinvalue']);
    });
    List<Map> _carbo_response = await _sqlDb.readData(
        "SELECT `Carbohydratesvalue` FROM 'Carbohydratestable' WHERE `Carbohydratesdate` > '${befor_fifteen_minutes}' AND `Carbohydratesdate` < '${Noww}'");
    _carbo_response.forEach((element) {
      _carbo_sum += double.parse(element['Carbohydratesvalue']);
    });
    if (_hr_sum != 0) {
      _hr_avg = _hr_sum / _hr_response.length;
    }
    if (_glucose_sum != 0) {
      _glucose_avg = _glucose_sum / _glucose_response.length;
    }
    setlast15(
      calories_sumg: calories_sum,
      carbo_sumg: _carbo_sum,
      glucose_avgg: _glucose_avg,
      hr_avgg: _hr_avg,
      insuline_sumg: _insuline_sum,
      steps_sumg: _steps_sum,
    );
  }

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

  // ****************************** Home Screen ******************************
  SqlDb _sqlDb = SqlDb();
  DateTime startofTheDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime endofTheDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(Duration(hours: 23, minutes: 59));
  int min_Glucose = 1000;
  int max_Glucose = 0;
  int last_Glucose_value = 0;
  late DateTime last_Glucose_date = startofTheDay;
  int avg_Glucose_value = 0;

  List<ChartSampleData> chartData = <ChartSampleData>[];
  List<Map> new_response = [];

  List<ChartSampleData> getChartData() {
    return chartData;
  }

  void setChartData(List<ChartSampleData> x) {
    chartData = x;
  }

  void setMinMaxGlucose(
      {required int min,
      required int max,
      required int last_value,
      required DateTime last_date,
      required int avg}) {
    min_Glucose = min;
    max_Glucose = max;
    last_Glucose_value = last_value;
    last_Glucose_date = last_date;
    avg_Glucose_value = avg;
  }

  List<dynamic> getMinMaxGlucose() {
    return [
      min_Glucose,
      max_Glucose,
      last_Glucose_value,
      last_Glucose_date,
      avg_Glucose_value
    ];
  }

  Future<void> fetchtodayglucose() =>
      Future.delayed(Duration(microseconds: 100), () async {
        refreshandfetch();
        chartData = <ChartSampleData>[];
        new_response = [];
        for (int i = 0; i < 96; i++) {
          List<Map> _newresponse = await _sqlDb.readData(
              "SELECT `Glucosevalue` FROM 'Glucosetable' WHERE `Glucosedate` > '${startofTheDay.add(new Duration(minutes: (i * 15)))}' AND `Glucosedate` < '${startofTheDay.add(new Duration(hours: ((i * 15) + 15)))}'");
          double sum = 0;
          _newresponse.forEach((element) {
            sum += double.parse(element['Glucosevalue']);
          });
          if ((sum / _newresponse.length).isNaN) {
            new_response.add(
                {'${startofTheDay.add(new Duration(minutes: (i * 15)))}': 0});
          } else {
            new_response.add({
              '${startofTheDay.add(new Duration(minutes: (i * 15)))}':
                  (sum ~/ _newresponse.length).toInt()
            });
          }
        }
        List<ChartSampleData> _getChartData = [];
        int current_value = 0;
        int _max_Glucose = 0;
        int _min_Glucose = 1000;
        int _last_Glucose_value = 0;
        int _sum_avg = 0;
        int _sum_avg_count = 0;
        int _avg = 0;
        DateTime _last_Glucose_date = startofTheDay;
        new_response.forEach((element) {
          current_value =
              double.parse('${element.values.single.toString()}').round();
          if (current_value != 0) {
            if (current_value > _max_Glucose) {
              _max_Glucose = current_value;
            }
            if (current_value < _min_Glucose) {
              _min_Glucose = current_value;
            }
            _last_Glucose_value = current_value;
            _last_Glucose_date =
                DateTime.parse('${element.keys.single.toString()}');
            _sum_avg += current_value;
            _sum_avg_count += 1;
          }

          _getChartData.add(ChartSampleData(
              DateTime.parse(element.keys.single.toString()),
              double.parse(element.values.single.toString())));
        });

        if (_sum_avg_count > 0) {
          _avg = _sum_avg ~/ _sum_avg_count;
        }
        setMinMaxGlucose(
            min: _min_Glucose,
            max: _max_Glucose,
            last_value: _last_Glucose_value,
            last_date: _last_Glucose_date,
            avg: _avg);
        set_condition_color_txt();
        setChartData(_getChartData);

        emit(HomeScreenRefreshedState());
      });

  Color codition_color = Colors.black;
  String codition_txt = 'Refresh';
  Color get_codition_color() {
    return codition_color;
  }

  String get_codition_text() {
    return codition_txt;
  }

  Future<void> set_condition_color_txt() async {
    if (getMinMaxGlucose()[2] < 54 && getMinMaxGlucose()[2] > 0) {
      codition_color = Color.fromARGB(255, 150, 0, 0);
      codition_txt = "Very Low";
      await FlutterPhoneDirectCaller.callNumber('${doc_num}');
    } else if (getMinMaxGlucose()[2] >= 54 && getMinMaxGlucose()[2] < 70) {
      codition_color = Color.fromARGB(255, 250, 20, 20);
      codition_txt = "Low";
    } else if (getMinMaxGlucose()[2] >= 70 && getMinMaxGlucose()[2] <= 180) {
      codition_color = Colors.green;
      codition_txt = "Normal";
    } else if (getMinMaxGlucose()[2] > 180 && getMinMaxGlucose()[2] <= 250) {
      codition_color = Color.fromARGB(255, 234, 238, 0);
      codition_txt = "High";
    } else if (getMinMaxGlucose()[2] > 250) {
      codition_color = Color.fromARGB(255, 250, 206, 10);
      codition_txt = "Very High";
    } else {
      codition_color = Colors.black;
      codition_txt = 'Refresh';
    }
  }
}
