import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/blood_glucose/cubit/cubit.dart';
import 'package:fristapp/modules/vitals/blood_glucose/cubit/states.dart';
import 'package:fristapp/shared/styles/icon_broken.dart';

class DateGlucose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GlucoseCubit, GlucoseStates>(
      listener: (context, state) {
        if (state is GlucoseChangeTopNavBartoDaysState) {
          GlucoseCubit.get(context).getMinMaxGlucose();
        }
      },
      builder: (context, state) {
        var cubit = GlucoseCubit.get(context);
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              color: Colors.grey[200],
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      color: Colors.white,
                      child: CalendarDatePicker(
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 1000)),
                        lastDate: DateTime.now(),
                        onDateChanged: (DateTime) {
                          cubit.setSelectedate(DateTime);
                          cubit.changetopNavBartoDay();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        width: 150,
                        height: 40,
                        color: Color.fromARGB(255, 187, 224, 255),
                        child: Center(
                          child: Text(
                            'Heart Rate',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Heart Rate Analysis',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.amber[200],
                                  radius: 15,
                                  child: Icon(
                                    IconBroken.Arrow___Up,
                                    color: Colors.amber[900],
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  'Highest',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  cubit.getMinMaxGlucose()[1] == 0
                                      ? '--'
                                      : '${cubit.getMinMaxGlucose()[1]}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  radius: 15,
                                  child: Icon(
                                    IconBroken.Arrow___Down,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  'Lowest',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  cubit.getMinMaxGlucose()[0] == 1000
                                      ? '--'
                                      : '${cubit.getMinMaxGlucose()[0]}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
