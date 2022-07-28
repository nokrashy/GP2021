import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fristapp/layout/cubit/cubit.dart';
import 'package:fristapp/layout/cubit/states.dart';
import 'package:fristapp/layout/home_layout.dart';
import 'package:fristapp/shared/component/constants.dart';
import 'package:fristapp/shared/network/local/cache_helper.dart';
import 'package:fristapp/shared/network/remote/dio_helper.dart';
import 'package:fristapp/shared/styles/bloc_observer.dart';
import 'package:fristapp/shared/styles/themes.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';
import 'layout/cubit/Constant/google_fit_functions.dart';
import 'layout/cubit/Constant/google_fit_functions.dart';
import 'layout/cubit/Notification.dart';
import 'modules/login/login_screen.dart';
import 'modules/on_boarding/on_boarding_screen.dart';
import 'modules/vitals/Height/cubit/cubit.dart';
import 'modules/vitals/blood_glucose/cubit/cubit.dart';
import 'modules/vitals/carbohydrates/cubit/cubit.dart';
import 'modules/vitals/heart_rate/cubit/cubit.dart';
import 'modules/vitals/insuline/cubit/cubit.dart';
import 'modules/vitals/steps/cubit/cubit.dart';
import 'modules/vitals/weight/cubit/cubit.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:geolocator/geolocator.dart';

// void printHello() {
//   print('HElllllllllloooooooooooooooo');
//   final DateTime now = DateTime.now();
//   final int isolateId = Isolate.current.hashCode;
//   print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CachHelper.init();
  Widget widget;
  uId = await CachHelper.getData(key: 'uId');
  bool isDark = await CachHelper.getData(key: 'isDark');
  bool isOn = await CachHelper.getData(key: 'isOn');
  bool isConnected = await CachHelper.getData(key: 'isConnected');
//
  await NotificationService().init().then((value) => print(
      "-------------------------------Notification INishalized------------------------"));

  // InitialiseNotification() {
  //   var initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var initializationSettingsIOS = IOSInitializationSettings();

  //   var initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid,
  //     iOS: initializationSettingsIOS,
  //   );

  //   FlutterLocalNotificationsPlugin().initialize(
  //     initializationSettings,
  //   );
  // }

//
  // await Permission.activityRecognition.request();

  if (uId != null) {
    widget = HomeLayout();
  } else {
    widget = OnBoardingScreen();
  }

  Stream<DatabaseEvent> data =
      FirebaseDatabase.instance.ref("Users").onChildAdded;
  Stream<DatabaseEvent> data2 = FirebaseDatabase.instance.ref("Users").onValue;

  print(data2.toList().then((value) {
    print(value);
  }));

  runApp(MyApp(isDark, widget, isOn, isConnected));

  // ALarm
  // final int helloAlarmID = 0;
  // await AndroidAlarmManager.periodic(
  //     const Duration(minutes: 1), helloAlarmID, printHello);
}

class MyApp extends StatelessWidget {
  final Widget statrWidget;
  final bool isDark;
  final bool isOn;
  final bool isConnected;
  MyApp(this.isDark, this.statrWidget, this.isOn, this.isConnected);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => GPCubit()
              ..ChangeAppMode(fromShared: isDark)
              ..getisConnected(fromShared: isConnected)
              ..ChangeisOn(fromShared: isOn)
              ..getUserData()
              ..fetchtodayglucose()
            // ..fetchData()
            // ..fetchStepData()
            ),
        BlocProvider(create: (context) => ConstantFunctinsCubit()),
        BlocProvider(create: (context) => StepsCubit()),
        BlocProvider(create: (context) => HrCubit()),
        BlocProvider(create: (context) => GlucoseCubit()),
        BlocProvider(create: (context) => WeightCubit()),
        BlocProvider(create: (context) => HeightCubit()),
        BlocProvider(create: (context) => insulinCubit()),
        BlocProvider(create: (context) => CarboCubit()),
      ],
      child: BlocConsumer<GPCubit, GPStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                GPCubit.get(context).IsDark ? ThemeMode.light : ThemeMode.light,
            // GPCubit.get(context).IsDark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: statrWidget,
          );
        },
      ),
    );
  }
}
