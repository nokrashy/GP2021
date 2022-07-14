import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

import 'Constant/google_fit_functions.dart';

class GPCubit extends Cubit<GPStates> {
  GPCubit() : super(InitialState());
  static GPCubit get(context) => BlocProvider.of(context);

  // ******************************      Main App Construction      ******************************
  int currentIndex = 0;
  List<String> appBartitle = ['Diabetes Mellitus', 'Vitals', 'Settings'];
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
    FirebaseAuth.instance.currentUser!.delete().then((value) {
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
      emit(ConnecttoFitSuccessState());
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
    bool _success7 =   await health
          .writeHealthData(1, HealthDataType.BODY_FAT_PERCENTAGE, now, now);
    bool _success8 = await health.writeHealthData(
        _temperatur_carbohydrates!, HealthDataType.BODY_TEMPERATURE, now, now);

   
    if (_success1 &
        _success2 &
        _success3 &
        _success4 &
        _success5 &
        _success6 &
        _success7 &
        _success8) {
      emit(DataAddedToGoogleFitSuccessState());
    } else {
      emit(DataAddedToGoogleFitErrorState());
    }
  }

  // ------------------------------------------------------

  final now = DateTime.now();
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

        // Fetch Steps from google fit and insert it in stepstable in the sql database
        List<HealthDataPoint> _steps = await ConstantFunctinsCubit()
            .fetchSteps(from: fetch_steps_from_date, to: now);

        _steps.forEach((element) async {
          int steps_response = await _sqlDb.insertData(
              "INSERT INTO `stepstable` ( `stepsdate`, `stepsvalue`) VALUES ( '${element.dateTo}' , ${element.value} )");
          print('Insert Step value in index Number ${steps_response}');
        });

        // Fetch Heart rate from google fit and insert it in stepstable in the sql database
        List<HealthDataPoint> _hr = await ConstantFunctinsCubit()
            .fetchHeartRate(from: fetch_hr_from_date, to: now);
        _hr.forEach((element) async {
          int hr_response = await _sqlDb.insertData(
              "INSERT INTO `hrtable` ( `hrdate`, `hrvalue` ) VALUES ( '${element.dateTo}' , ${element.value})");
          print('Insert Hr value in index Number ${hr_response}');
        });
        // Fetch Calories from google fit and insert it in stepstable in the sql database
        List<HealthDataPoint> _calories = await ConstantFunctinsCubit()
            .fetchCalories(from: fetch_calories_from_date, to: now);
        _calories.forEach((element) async {
          print(element.dateFrom);
          print(element.dateTo);
          print(element.value.round());
          int calories_response = await _sqlDb.insertData(
              // "INSERT INTO `caloriestable` (`caloriesdate`,`caloriesvalue` ,`untillcaloriesdate`) VALUES ( '${int.parse(element.dateFrom.toString())}' , ${element.value} , ${element.dateTo} )");
              ''' INSERT INTO `caloriestable` 
              (`caloriesdate`,`caloriesvalue`, `untillcaloriesdate`) 
              VALUES 
              ( '${element.dateFrom}' ,'${element.value.round()}','${element.dateTo}')
              ''');

          print('Insert calories value in index Number ${calories_response}');
        });

        // Fetch Weight from google fit and insert it in weighttable in the sql database
        List<HealthDataPoint> _weightList = await ConstantFunctinsCubit()
            .fetchWeight(from: fetch_weight_from_date, to: now);
        _weightList.forEach((element) async {
          int weight_response = await _sqlDb.insertData(
              "INSERT INTO `weighttable` ( `weightsdate`, `weightvalue` ) VALUES ( '${element.dateTo}' , ${element.value})");
          print('Insert Weight value in index Number ${weight_response}');
        });

        // Fetch Height from google fit and insert it in heighttable in the sql database
        List<HealthDataPoint> _heightList = await ConstantFunctinsCubit()
            .fetchHeight(from: fetch_height_from_date, to: now);
        _heightList.forEach((element) async {
          int height_response = await _sqlDb.insertData(
              "INSERT INTO `heighttable` ( `heightdate`, `heightvalue` ) VALUES ( '${element.dateTo}' , ${element.value})");
          print('Insert Height value in index Number ${height_response}');
        });

        // Fetch Glucose from google fit and insert it in Glucosetable in the sql database
        List<HealthDataPoint> _glucoseList = await ConstantFunctinsCubit()
            .fetchBloodGlucose(from: fetch_glucose_from_date, to: now);
        _glucoseList.forEach((element) async {
          print(element);
          int glucose_response = await _sqlDb.insertData(
              "INSERT INTO `Glucosetable` ( `Glucosedate`, `Glucosevalue` ) VALUES ( '${element.dateTo}' , ${element.value})");
          print('Insert Glucose value in index Number ${glucose_response}');
        });

        // Fetch fat_insuline from google fit and insert it in Glucosetable in the sql database
        List<HealthDataPoint> _insulineList = await ConstantFunctinsCubit()
            .fetchFatInsuline(
                from: fetch_fat_insuline, to: now);
        _insulineList.forEach((element) async {
          print(element);
          int insuline_response = await _sqlDb.insertData(
              "INSERT INTO `Insulintable` ( `Insulindate`, `Insulinvalue` ) VALUES ( '${element.dateTo}' , ${element.value})");
          print('Insert Insuline value in index Number ${insuline_response}');
        });

        // Fetch  Temperatur_carbohydrates from google fit and insert it in Glucosetable in the sql database
        List<HealthDataPoint> _carbohydratesList = await ConstantFunctinsCubit()
            .fetchTemperaturCarbohydrates(
                from: fetch_temperatur_carbohydrates, to: now);
        _carbohydratesList.forEach((element) async {
          print(element);
          int carbohydrates_response = await _sqlDb.insertData(
              "INSERT INTO `Carbohydratestable` ( `Carbohydratesdate`, `Carbohydratesvalue` ) VALUES ( '${element.dateTo}' , ${element.value})");
          print(
              'Insert Carbohydrates value in index Number ${carbohydrates_response}');
        });

        emit(RefreshAndFetchDataState());
      });
// -----------------------------------------------------------------------------------------------------------
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

  // Handle Model

  fetchModel(String url) async {
    try {
      emit(MOdelLoadingState());
      http.Response response = await http.get(Uri.parse(url));
      emit(MOdelrSuccessState());
      return response.body;
    } catch (e) {
      print('Error: ${e}');
      emit(MOdelErrorState());
    }
  }

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
    const oneSec = Duration(minutes: 5);
    timer = Timer.periodic(oneSec, (Timer t) {
      print("**********************");
      print(DateTime.now());
      showToast(msg: "Data Added", state: toastStates.SUCCESS);
      addData();
      emit(ModelCycleState());
    });
  }

  void modelCycleOff() {
    if (timer != null) {
      timer?.cancel();
      print('Timer Turned OFF');
    }

    emit(ModelCycleOFFState());
  }

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
}
