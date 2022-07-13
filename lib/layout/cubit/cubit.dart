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

class GPCubit extends Cubit<GPStates> {
  GPCubit() : super(InitialState());
  static GPCubit get(context) => BlocProvider.of(context);
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

// create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  List<HealthDataPoint> healthDataList = [];
// AppState _state = AppState.DATA_NOT_FETCHED;
  int? nofsteps;

  HealthDataPoint? lastDateSteps;
  HealthDataPoint? lastDateWeight;
  HealthDataPoint? lastDateHeight;
  HealthDataPoint? lastDateBloodGlucose;
  HealthDataPoint? lastDateHeartRate;
  HealthDataPoint? lastDateEnergyBurned;
  HealthDataPoint? lastDateBloodOxygen;
  HealthDataPoint? lastDateBodyTemperatur;
  HealthDataPoint? lastDateBloodPressureSystolic;
  HealthDataPoint? lastDateBloodPressureDiastolic;

  double _mgdl = 10.0;
  double _hr = 80;
  double _steps = 50;
  double _calories = 17;

// Alarm

  // Future<void> Alarm() async {
  //   print('*********************************');
  //   final int helloAlarmID = 0;
  //   await AndroidAlarmManager.periodic(
  //       const Duration(minutes: 1), helloAlarmID, printHello);
  // }

  // void printHello() {
  //   print('HElllllllllloooooooooooooooo');
  //   final DateTime now = DateTime.now();
  //   final int isolateId = Isolate.current.hashCode;
  //   print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  // }

  /// Add some random health data.
  Future addData() async {
    final now = DateTime.now();
    final earlier = now.subtract(Duration(minutes: 5));

    // nofsteps = Random().nextInt(10);
    nofsteps = 100;
    final types = [
      HealthDataType.STEPS,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.HEART_RATE,
      HealthDataType.ACTIVE_ENERGY_BURNED
    ];
    final rights = [
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE
    ];
    final permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
    ];
    bool? hasPermissions =
        await HealthFactory.hasPermissions(types, permissions: rights);
    if (hasPermissions == false) {
      await health.requestAuthorization(types, permissions: permissions);
    }

    // _mgdl = Random().nextInt(10) * 1.0;
    _mgdl = Random().nextInt(80) + 50;
    _hr = Random().nextInt(50) + 60;
    _steps = Random().nextInt(250) + 0;
    _calories = Random().nextInt(10) + 17;
    // bool success = await health.writeHealthData(
    //     nofsteps!.toDouble(), HealthDataType.STEPS, earlier, now);

    bool success = true;

    // bool success = await health.writeHealthData(
    //     nofsteps!.toDouble(), HealthDataType.STEPS, earlier, now);

    if (success) {
      success = await health.writeHealthData(
          _mgdl, HealthDataType.BLOOD_GLUCOSE, now, now);
      await health.writeHealthData(
          _steps.toDouble(), HealthDataType.STEPS, earlier, now);
      await health.writeHealthData(_hr, HealthDataType.HEART_RATE, now, now);
      await health.writeHealthData(_calories.toDouble(),
          HealthDataType.ACTIVE_ENERGY_BURNED, earlier, now);
    }
    if (success) {
      emit(DataAddedToGoogleFitSuccessState());
    } else {
      emit(DataAddedToGoogleFitErrorState());
    }
  }

  // ---------------------------------------------------------------------------
  // Request Connect to google fit
  bool requested = false;

  bool getrequested() {
    return requested;
  }

  void setrequested(bool req) {
    requested = req;
  }

  Future Request_Connect() async {
    emit(StartConnecttoFitState());
    // define the types to get
    final types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BODY_TEMPERATURE,
    ];
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];
    bool _requested =
        await health.requestAuthorization(types, permissions: permissions);
    print(_requested);

    if (_requested) {
      setrequested(true);
      emit(ConnecttoFitSuccessState());
    } else {
      setrequested(false);
      emit(ConnecttoFitFailedsState());
    }
  }

// Fetch Steps
  Future fetchSteps({required final from, required final to}) async {
    emit(StepsStartFetchedState());
    List<HealthDataPoint> stepsHealthDataList = [];
    bool requested = await health.requestAuthorization([HealthDataType.STEPS],
        permissions: [HealthDataAccess.READ]);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health
            .getHealthDataFromTypes(from, to, [HealthDataType.STEPS]);
        stepsHealthDataList.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      stepsHealthDataList = HealthFactory.removeDuplicates(stepsHealthDataList);
      if (stepsHealthDataList.isEmpty) {
        emit(StepsNotFetchedState());
      } else {
        emit(StepsFetchedSucessfullyState());
      }
    } else {
      print("Authorization not granted");
      emit(StepsAuthorizationNotGrantedState());
    }
    return stepsHealthDataList;
  }

  // Fetch Heart Rate
  Future fetchHeartRate({required final from, required final to}) async {
    emit(HrStartFetchedState());
    List<HealthDataPoint> heartRateDataList = [];
    bool requested = await health.requestAuthorization(
        [HealthDataType.HEART_RATE],
        permissions: [HealthDataAccess.READ]);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health
            .getHealthDataFromTypes(from, to, [HealthDataType.HEART_RATE]);
        heartRateDataList.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      heartRateDataList = HealthFactory.removeDuplicates(heartRateDataList);

      if (heartRateDataList.isEmpty) {
        emit(HrNotFetchedState());
      } else {
        emit(HrFetchedSucessfullyState());
      }
    } else {
      emit(HrAuthorizationNotGrantedState());
    }

    return heartRateDataList;
  }

  // fetch calories
  Future fetchCalories({required final from, required final to}) async {
    emit(caloriesStartFetchedState());
    List<HealthDataPoint> caloriesDataList = [];
    bool requested = await health.requestAuthorization(
        [HealthDataType.ACTIVE_ENERGY_BURNED],
        permissions: [HealthDataAccess.READ]);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
            from, to, [HealthDataType.ACTIVE_ENERGY_BURNED]);
        caloriesDataList.addAll(healthData);
        print(caloriesDataList);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      caloriesDataList = HealthFactory.removeDuplicates(caloriesDataList);

      if (caloriesDataList.isEmpty) {
        emit(caloriesNotFetchedState());
      } else {
        emit(caloriesFetchedSucessfullyState());
      }
    } else {
      emit(caloriesAuthorizationNotGrantedState());
    }
    return caloriesDataList;
  }

  // fetch SystolicPressure
  Future fetchSystolicPressure({required final from, required final to}) async {
    emit(SystolicpressureStartFetchedState());
    List<HealthDataPoint> systolicpressureDataList = [];
    bool requested = await health.requestAuthorization(
        [HealthDataType.BLOOD_PRESSURE_SYSTOLIC],
        permissions: [HealthDataAccess.READ]);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
            from, to, [HealthDataType.BLOOD_PRESSURE_SYSTOLIC]);
        systolicpressureDataList.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      systolicpressureDataList =
          HealthFactory.removeDuplicates(systolicpressureDataList);

      if (systolicpressureDataList.isEmpty) {
        emit(SystolicpressureNotFetchedState());
      } else {
        emit(SystolicpressureFetchedSucessfullyState());
      }
    } else {
      print("Authorization not granted");
      emit(SystolicpressureAuthorizationNotGrantedState());
    }
    // systolicpressureDataList.forEach((x) {
    //   print(x);
    // });
    return systolicpressureDataList;
  }

  // fetch DiastolicPressure
  Future fetchDiastolicPressure(
      {required final from, required final to}) async {
    emit(DiastolicpressureStartFetchedState());
    List<HealthDataPoint> diastolicpressureDataList = [];
    bool requested = await health.requestAuthorization(
        [HealthDataType.BLOOD_PRESSURE_DIASTOLIC],
        permissions: [HealthDataAccess.READ]);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
            from, to, [HealthDataType.BLOOD_PRESSURE_DIASTOLIC]);

        diastolicpressureDataList.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      diastolicpressureDataList =
          HealthFactory.removeDuplicates(diastolicpressureDataList);

      if (diastolicpressureDataList.isEmpty) {
        emit(DiastolicpressureNotFetchedState());
      } else {
        emit(DiastolicpressureFetchedSucessfullyState());
        // print(diastolicpressureDataList);
      }
    } else {
      print("Authorization not granted");
      emit(DiastolicpressureAuthorizationNotGrantedState());
    }
    // diastolicpressureDataList.forEach((x) {
    //   print(x);
    // });
    return diastolicpressureDataList;
  }

  // ---------------------------------------------------------------------------

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {
    print('hello from fetch data');
    emit(FetchingDataFromGoogleFitState());

    // setState(() => _state = AppState.FETCHING_DATA);
    // define the types to get
    final types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,

      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BODY_TEMPERATURE,

      // HealthDataType.BASAL_ENERGY_BURNED,
      // HealthDataType.BODY_FAT_PERCENTAGE,
      // HealthDataType.BODY_MASS_INDEX,
      // HealthDataType.DIETARY_CARBS_CONSUMED,
      // HealthDataType.DIETARY_ENERGY_CONSUMED,
      // HealthDataType.DIETARY_FATS_CONSUMED,
      // HealthDataType.DIETARY_PROTEIN_CONSUMED,
      // HealthDataType.FORCED_EXPIRATORY_VOLUME,
      // HealthDataType.HEART_RATE_VARIABILITY_SDNN,
      // HealthDataType.RESTING_HEART_RATE,
      // HealthDataType.WAIST_CIRCUMFERENCE,
      // HealthDataType.WALKING_HEART_RATE,
      // HealthDataType.DISTANCE_WALKING_RUNNING,
      // HealthDataType.FLIGHTS_CLIMBED,
      // HealthDataType.MOVE_MINUTES,
      // HealthDataType.DISTANCE_DELTA,
      // HealthDataType.MINDFULNESS,
      // HealthDataType.WATER,
      // SLEEP_IN_BED,
      // HealthDataType.SLEEP_ASLEEP,
      // HealthDataType.SLEEP_AWAKE,
      // HealthDataType.EXERCISE_TIME,
      // HealthDataType.WORKOUT,
      // HealthDataType.HEADACHE_NOT_PRESENT,
      // HealthDataType.HEADACHE_MILD,
      // HealthDataType.HEADACHE_MODERATE,
      // HealthDataType.HEADACHE_SEVERE,
      // HealthDataType.HEADACHE_UNSPECIFIED,
    ];

    // with coresponsing permissions
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));
    final lastmonth = now.subtract(Duration(days: 30));

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            // await health.getHealthDataFromTypes(yesterday, now, types);
            await health.getHealthDataFromTypes(lastmonth, now, types);

        // save all the new data points (only the first 100)
        healthDataList.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      healthDataList = HealthFactory.removeDuplicates(healthDataList);

      // print the results
      healthDataList.forEach((x) {
        print(x);
        if (x.typeString == 'ACTIVE_ENERGY_BURNED') {
          lastDateEnergyBurned = x;
        }
        if (x.typeString == 'BLOOD_PRESSURE_SYSTOLIC') {
          lastDateBloodPressureSystolic = x;
        }

        if (x.typeString == 'BLOOD_GLUCOSE') {
          lastDateBloodGlucose = x;
        }
        if (x.typeString == 'STEPS') {
          lastDateSteps = x;
        }

        if (x.typeString == 'BLOOD_PRESSURE_DIASTOLIC') {
          lastDateBloodPressureDiastolic = x;
        }
        if (x.typeString == 'BLOOD_OXYGEN') {
          lastDateBloodOxygen = x;
        }

        if (x.typeString == 'BODY_TEMPERATURE') {
          lastDateBodyTemperatur = x;
        }
        if (x.typeString == 'HEART_RATE') {
          lastDateHeartRate = x;
        }

        if (x.typeString == 'HEIGHT') {
          lastDateHeight = x;
        }
        if (x.typeString == 'WEIGHT') {
          lastDateWeight = x;
        }
        // if (x.typeString != 'ACTIVE_ENERGY_BURNED' ||
        //     x.typeString != 'BLOOD_PRESSURE_SYSTOLIC' ||
        //     x.typeString != 'BLOOD_GLUCOSE' ||
        //     x.typeString != 'STEPS' ||
        //     x.typeString != 'BLOOD_PRESSURE_DIASTOLIC' ||
        //     x.typeString != 'BLOOD_OXYGEN' ||
        //     x.typeString != 'BODY_TEMPERATURE' ||
        //     x.typeString != 'HEART_RATE') {
        //   print(x.typeString);
        // }
      });

      if (healthDataList.isEmpty) {
        emit(NoDataFromGoogleFitState());
      } else {
        emit(DataReadyFromGoogleFitState());
      }
    } else {
      print("Authorization not granted");
      emit(DataNotFetchedFromGoogleFitState());
      // setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  /// Fetch steps from the health plugin and show them in the app.
  Future fetchStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    // final midnight = DateTime(now.year, now.month, now.day);
    final before_hour = now.subtract(const Duration(hours: 1));

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(before_hour, now);
        // steps = await health.getTotalStepsInInterval(midnight, now);

        print(steps);
        // print(midnight);
        print(now);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $steps');
      emit(FetchingStepsFromGoogleFitState());

      if (steps == null) {
        nofsteps = 0;
        emit(NoStepsFromGoogleFitState());
      } else {
        nofsteps = steps;
        emit(StepsReadyFromGoogleFitState());
      }

      // setState(() {
      //   nofsteps = (steps == null) ? 0 : steps;
      //   _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
      // });
    } else {
      print("Authorization not granted");
      emit(StepsNotFetchedFromGoogleFitState());
      // setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView.builder(
        itemCount: healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = healthDataList[index];
          return ListTile(
            title: Text("${p.typeString}: ${p.value}"),
            trailing: Text('${p.unitString}'),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }

  Widget _contentNoData() {
    return Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Column(
      children: [
        Text('Press the download button to fetch data.'),
        Text('Press the plus button to insert some random data.'),
        Text('Press the walking button to get total step count.'),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _authorizationNotGranted() {
    return Text('Authorization not given. '
        'For Android please check your OAUTH2 client ID is correct in Google Developer Console. '
        'For iOS check your permissions in Apple Health.');
  }

  Widget _dataAdded() {
    return Text('$nofsteps steps and $_mgdl mgdl are inserted successfully!');
  }

  Widget _stepsFetched() {
    return Text('Total number of steps: $nofsteps');
  }

  Widget _dataNotAdded() {
    return Text('Failed to add data');
  }

  final now = DateTime.now();
  final yesterday = DateTime.now().subtract(Duration(days: 2));
  final lastmonth = DateTime.now().subtract(Duration(days: 10));

  Future<void> refreshandfetch() =>
      Future.delayed(Duration(seconds: 2), () async {
        print('*************************************************************');
        SqlDb _sqlDb = SqlDb();
        DateTime fetch_steps_from_date;
        DateTime fetch_hr_from_date;
        DateTime fetch_calories_from_date;

        List<Map> last_date_in_steps_db = await _sqlDb.readData(
            "SELECT `stepsdate` FROM 'stepstable' ORDER BY `id` DESC LIMIT 1");
        List<Map> last_date_in_hr_db = await _sqlDb.readData(
            "SELECT `hrdate` FROM 'hrtable' ORDER BY `id` DESC LIMIT 1");
        List<Map> last_date_in_calories_db = await _sqlDb.readData(
            "SELECT `caloriesdate` FROM 'caloriestable' ORDER BY `id` DESC LIMIT 1");

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
        // Fetch Steps from google fit and insert it in stepstable in the sql database
        List<HealthDataPoint> _steps =
            await fetchSteps(from: fetch_steps_from_date, to: now);

        _steps.forEach((element) async {
          int steps_response = await _sqlDb.insertData(
              "INSERT INTO `stepstable` ( `stepsdate`, `stepsvalue`) VALUES ( '${element.dateTo}' , ${element.value} )");
          print('Insert Step value in index Number ${steps_response}');
        });

        // Fetch Heart rate from google fit and insert it in stepstable in the sql database
        List<HealthDataPoint> _hr =
            await fetchHeartRate(from: fetch_hr_from_date, to: now);
        _hr.forEach((element) async {
          int hr_response = await _sqlDb.insertData(
              "INSERT INTO `hrtable` ( `hrdate`, `hrvalue` ) VALUES ( '${element.dateTo}' , ${element.value})");
          print('Insert Hr value in index Number ${hr_response}');
        });
        // Fetch Calories from google fit and insert it in stepstable in the sql database
        List<HealthDataPoint> _calories =
            await fetchCalories(from: fetch_calories_from_date, to: now);
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

        // Fetch fetchSystolicPressure from google fit and insert it in stepstable in the sql database
        // fetchSystolicPressure(from: lastmonth, to: now);

        emit(RefreshAndFetchDataState());

        // //*******************
        // fetchData();
        // fetchStepData();
        // fetchData();
      });

// Data
  // Future fetchStepDataSpecificDay() async {
  //   int? steps;
  //   final now = DateTime.now();
  //   final midnight = DateTime(now.year, now.month, now.day);
  //   final before_hour = now.subtract(const Duration(hours: 1));

  //   bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

  //   if (requested) {
  //     try {
  //       steps = await health.getTotalStepsInInterval(before_hour, now);
  //       // steps = await health.getTotalStepsInInterval(midnight, now);

  //       print(steps);
  //       print(midnight);
  //       print(now);
  //     } catch (error) {
  //       print("Caught exception in getTotalStepsInInterval: $error");
  //     }

  //     print('Total number of steps: $steps');
  //     emit(Fetchingfetch_from_dateGoogleFitState());

  //     if (steps == null) {
  //       nofsteps = 0;
  //       emit(Nofetch_from_dateGoogleFitState());
  //     } else {
  //       nofsteps = steps;
  //       emit(StepsReadyFromGoogleFitState());
  //     }

  //     // setState(() {
  //     //   nofsteps = (steps == null) ? 0 : steps;
  //     //   _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
  //     // });
  //   } else {
  //     print("Authorization not granted");
  //     emit(StepsNotFetchedFromGoogleFitState());
  //     // setState(() => _state = AppState.DATA_NOT_FETCHED);
  //   }
  // }

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
}
