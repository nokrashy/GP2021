import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/layout/cubit/cubit.dart';
import 'package:fristapp/layout/cubit/states.dart';
import 'package:fristapp/modules/login/cubit/cubit.dart';
import 'package:fristapp/modules/login/login_screen.dart';
import 'package:fristapp/modules/on_boarding/on_boarding_screen.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:fristapp/shared/component/constants.dart';
import 'package:fristapp/shared/network/local/cache_helper.dart';
import 'package:fristapp/shared/network/local/sqldb.dart';
import 'package:fristapp/shared/styles/icon_broken.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:health/health.dart';
import '../Firebase/reset_password.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Settingsscreen extends StatelessWidget {
  late final AudioCache _audioCache;
  TextEditingController newDocNum = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GPCubit, GPStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GPCubit.get(context);
        var usermodel = cubit.usermodel;
        newDocNum.text = usermodel!.phone;
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Container(
                            height: 200.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    20.0,
                                  ),
                                  topRight: Radius.circular(
                                    20.0,
                                  ),
                                  bottomLeft: Radius.circular(
                                    20.0,
                                  ),
                                  bottomRight: Radius.circular(
                                    20.0,
                                  ),
                                ),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/cover.jpg'),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        // Align(
                        //   child: CircleAvatar(
                        //     radius: 55.0,
                        //     foregroundColor: Colors.white,
                        //     backgroundColor: Colors.white,
                        //     child: CircleAvatar(
                        //       radius: 60.0,
                        //       backgroundImage: NetworkImage(
                        //         usermodel.image != null
                        //             ? '${usermodel.image}'
                        //             : 'https://firebasestorage.googleapis.com/v0/b/first-ptoject-c0cec.appspot.com/o/default%2Fpharmacist.png?alt=media&token=597ebcef-6b26-46f4-b579-672805412efb',
                        //       ),
                        //     ),
                        //   ),
                        //   alignment: AlignmentDirectional.bottomStart,
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Card(
                    color: Colors.white,
                    child: Row(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '\tPersonal information',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 20.0,
                              color: Colors.blue,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '\t\t${usermodel.name}',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '\t${usermodel.email}',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: TextButton(
                                onPressed: () {
                                  NavigetTo(context, ResetScreen());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Reset password ',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Icon(Icons.share_arrival_time_outlined),
                                  ],
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ]),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  Card(
                    color: Colors.white,
                    child: Row(children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '\tStatus',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                fontSize: 20.0,
                                color: Colors.blue,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '\tGlucose tracking',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    Transform.scale(
                                      scale: 1,
                                      child: Switch(
                                        value: cubit.isOn,
                                        onChanged: (value) async {
                                          if (cubit.isConnected) {
                                            cubit.ChangeisOn(fromShared: value);
                                          } else {
                                            showToast(
                                                msg:
                                                    'Connect to google Fit First',
                                                state: toastStates.WARNING);
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      cubit.isOn ? 'On' : 'Off',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  '\t Doctor Number: ${cubit.doc_num}',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text('Doctor Number'),
                                                content: TextField(
                                                  autofocus: true,
                                                  controller: newDocNum,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Number of the attending physician'),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      }),
                                                  TextButton(
                                                      child: Text('Submit'),
                                                      onPressed: () {
                                                        cubit.edite_number(
                                                            newDocNum.text,
                                                            context);
                                                        if (cubit.isupdated) {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(Users)
                                                              .doc(
                                                                  usermodel.uId)
                                                              .update({
                                                            'phone':
                                                                cubit.doc_num
                                                          }).then((value) {
                                                            cubit.isupdated =
                                                                false;
                                                            print(
                                                                'Number Updated');
                                                          });
                                                        }
                                                      }),
                                                ],
                                              ));
                                      // _audioCache.play('my_audio.mp3');
                                    },
                                    icon: Row(
                                      children: [
                                        Icon(
                                          IconBroken.Edit,
                                          color: Colors.blue,
                                          size: 30.0,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 15.0,
                                ),
                                Container(
                                  height: 40,
                                  child: Center(
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        cubit.Request_Connect();
                                      },
                                      child: Text(
                                        cubit.isConnected
                                            ? 'Connected to google fit ✅'
                                            : 'Tap to connect google fit ⚠️',
                                        style: cubit.isConnected
                                            ? Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.green,
                                                )
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color.fromARGB(
                                                      255, 206, 185, 0),
                                                ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 14.0,
                            ),
                          ]),
                    ]),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),

                  // Dark Mode
                  // Container(
                  //   height: 20.0,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Text(
                  //           'Dark Mode',
                  //           style:
                  //               Theme.of(context).textTheme.bodyText1!.copyWith(
                  //                     fontSize: 18.0,
                  //                     fontWeight: FontWeight.normal,
                  //                   ),
                  //         ),
                  //       ),
                  //       Switch(
                  //         value: GPCubit.get(context).IsDark,
                  //         onChanged: (value) {
                  //           GPCubit.get(context).ChangeAppMode();
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              onPressed: () {
                                CachHelper.removeData(key: 'uId');
                                cubit.currentIndex = 0;
                                NavidetAndFinish(context, LoginScreen());
                              },
                              child: Text(
                                'Log Out',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Delete Account'),
                                  content: const Text(
                                    'Erase all your data',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        cubit.UserDeleteAccount();
                                        CachHelper.removeData(key: 'uId');
                                        cubit.currentIndex = 0;
                                        NavidetAndFinish(
                                            context, OnBoardingScreen());
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
                              child: Text(
                                'Delete Your Account',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromARGB(255, 241, 27, 27),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      // / initial notifications
                      // cubit.InitialiseNotification();

                      Timer(Duration(seconds: 3), () {
                        cubit.SendNotification2();
                      });
                    },
                    child: Text('Send Notification'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
