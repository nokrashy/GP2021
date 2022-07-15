import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/Height/cubit/cubit.dart';
import 'package:fristapp/modules/vitals/height/cubit/states.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:fristapp/shared/styles/icon_broken.dart';
import 'package:intl/intl.dart';
import '../../../layout/cubit/cubit.dart';
import '../../../shared/styles/MyIcon.dart.dart';

class Height extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = HeightCubit.get(context);
    return BlocConsumer<HeightCubit, HeightStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState!.validate()) {
                  // Handle DateTime
                  List dateList = dateController.text.split('/');
                  String newDate =
                      '${dateList[2]}-${dateList[0]}-${dateList[1]}';
                  DateTime time_and_oldDate =
                      DateFormat.jm().parse(timeController.text);
                  String datetimeString = time_and_oldDate
                      .toString()
                      .replaceFirst('1970-01-01', newDate);
                  DateTime timeDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
                      .parse(datetimeString);

                  //
                  cubit.addHeightToGooglefit(
                    Height: double.parse(titleController.text),
                    date: timeDate,
                  );
                  GPCubit().refreshandfetch();

                  Navigator.pop(context);

                  titleController.text = '';
                  timeController.text = '';
                  dateController.text = '';
                }
              } else {
                scaffoldKey.currentState
                    ?.showBottomSheet(
                      (context) => Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(
                          20.0,
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defultFormField(
                                lable: 'Height',
                                controller: titleController,
                                type: TextInputType.number,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter your Height';
                                  }
                                  if (double.parse(value) > 200 ||
                                      double.parse(value) < 20) {
                                    return 'please enter a valid Height';
                                  }
                                },
                                prefix: MyIcon.text_height,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              defultFormField(
                                lable: 'Date',
                                controller: dateController,
                                type: TextInputType.datetime,
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(Duration(days: 30)),
                                    lastDate: DateTime.now(),
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMd().format(value!);
                                    print(dateController.text);
                                  });
                                },
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'date must not be empty';
                                  }
                                },
                                prefix: Icons.calendar_today,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              defultFormField(
                                controller: timeController,
                                type: TextInputType.datetime,
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text =
                                        value!.format(context).toString();
                                    print(timeController.text);
                                  });
                                },
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'time must not be empty';
                                  }
                                },
                                lable: 'Time',
                                prefix: Icons.watch_later_outlined,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      elevation: 20.0,
                    )
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetState(
                    isShow: false,
                    icon: Icons.edit,
                  );
                });

                cubit.changeBottomSheetState(
                  isShow: true,
                  icon: Icons.add,
                );
              }
            },
            child: Icon(
              cubit.fabIcon,
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(IconBroken.Arrow___Left_2),
            ),
            title: Text(
              'Height',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => cubit.readData(
                from: cubit.getSelectedate(), to: DateTime.now()),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                        ),
                        color: Color.fromARGB(255, 235, 233, 233),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue,
                            blurRadius: 5,
                          )
                        ]),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text(
                              cubit.getrsponse().isEmpty ? "" : 'Height ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25.0),
                            ))),
                            Expanded(
                                child: Center(
                                    child: Text(
                              cubit.getrsponse().isEmpty
                                  ? 'Refresh to see Your Height'
                                  : '${((double.parse((cubit.getrsponse().last['heightvalue'])) * 100)).round()}',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25.0),
                            ))),
                            Expanded(
                                child: Center(
                                    child: Text(
                              cubit.getrsponse().isEmpty ? '' : 'Cm',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25.0),
                            ))),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text(
                              cubit.getrsponse().isEmpty ? "" : 'Last update',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25.0),
                            ))),
                            Expanded(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      cubit.getrsponse().isEmpty
                                          ? ""
                                          : '${cubit.getrsponse().last['heightdate'].toString().substring(0, 10)}',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 25.0),
                                    ),
                                    Text(
                                      cubit.getrsponse().isEmpty
                                          ? ""
                                          : '${cubit.getrsponse().last['heightdate'].toString().substring(10, 16)}',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 25.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                                '${cubit.getrsponse()[index]['heightdate'].toString().substring(0, 16)}'),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Center(
                                  child: Text('Height'),
                                )),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                        '${(double.parse((cubit.getrsponse()[cubit.getrsponse().length - index - 1]['heightvalue'])) * 100).round()}'),
                                  ),
                                ),
                                Expanded(child: Center(child: Text('Cm'))),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            MyDivider(),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        );
                      },
                      itemCount: cubit.getrsponse().length,
                    ),
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
