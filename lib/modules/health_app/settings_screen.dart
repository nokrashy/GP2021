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
                            height: 150.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  10.0,
                                ),
                                topRight: Radius.circular(
                                  10.0,
                                ),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  usermodel.cover != null
                                      ? '${usermodel.cover}'
                                      : 'https://firebasestorage.googleapis.com/v0/b/first-ptoject-c0cec.appspot.com/o/default%2Fhospital.png?alt=media&token=9f64353a-cc3f-45ce-a2ae-d79510f78790',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        Align(
                          child: CircleAvatar(
                            radius: 55.0,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundImage: NetworkImage(
                                usermodel.image != null
                                    ? '${usermodel.image}'
                                    : 'https://firebasestorage.googleapis.com/v0/b/first-ptoject-c0cec.appspot.com/o/default%2Fpharmacist.png?alt=media&token=597ebcef-6b26-46f4-b579-672805412efb',
                              ),
                            ),
                          ),
                          alignment: AlignmentDirectional.bottomStart,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${usermodel.name}',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: defultColor,
                                    ),
                          ),
                          Text(
                            '${usermodel.email}',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  MyDivider(),
                  SizedBox(
                    height: 14.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 5.0,
                      top: 5.0,
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Doctor Number: ${cubit.doc_num}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
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
                                                    newDocNum.text, context);
                                                if (cubit.isupdated) {
                                                  FirebaseFirestore.instance
                                                      .collection(Users)
                                                      .doc(usermodel.uId)
                                                      .update({
                                                    'phone': cubit.doc_num
                                                  }).then((value) {
                                                    cubit.isupdated = false;
                                                    print('Number Updated');
                                                  });
                                                }
                                              }),
                                        ],
                                      ));
                              // _audioCache.play('my_audio.mp3');
                            },
                            icon: Icon(IconBroken.Edit)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          child: OutlinedButton(
                            onPressed: () async {
                              cubit.Request_Connect();
                            },
                            child: Text(
                              'Link to Google Fit',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    color: defultColor,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  MyDivider(),
                  SizedBox(
                    height: 14.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Activate',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: cubit.isOn,
                            onChanged: (value) async {
                              cubit.ChangeisOn(fromShared: value);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          child: OutlinedButton(
                            onPressed: () async {
                              SqlDb _sqlDb = SqlDb();
                              await _sqlDb.mydeleteDatabase();
                            },
                            child: Text(
                              'Delete Your Information',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.red,
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
                  MyDivider(),
                  Container(
                    height: 20.0,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Dark Mode',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                        Switch(
                          value: GPCubit.get(context).IsDark,
                          onChanged: (value) {
                            GPCubit.get(context).ChangeAppMode();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          child: OutlinedButton(
                            onPressed: () {
                              NavidetAndFinish(context, LoginScreen());
                              CachHelper.removeData(key: 'uId');
                              cubit.currentIndex = 0;
                            },
                            child: Text(
                              'Log Out',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    color: defultColor,
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
                          child: OutlinedButton(
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
                                      NavidetAndFinish(
                                          context, OnBoardingScreen());
                                      CachHelper.removeData(key: 'uId');
                                      cubit.currentIndex = 0;
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
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
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
                      child: Text('Make Action'),
                      onPressed: () async {
                        await FlutterPhoneDirectCaller.callNumber(
                            '${cubit.doc_num}');
                        // 01017253775
                        print('Done');
                      }),
                      SizedBox(
                        height: 10,
                      ),
                  RaisedButton(
                      child: Text('ADD data to google fit'),
                      onPressed: () async {
                        cubit.addData();
                        print('Data Added');
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
