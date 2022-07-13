import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/steps/cubit/cubit.dart';
import 'package:fristapp/modules/vitals/steps/cubit/states.dart';

class DateSteps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StepsCubit, StepsStates>(
      listener: (context, state) {
        if (state is ChangeTopNavBartoDaysState) {
          StepsCubit.get(context).getsumSteps();
        }
      },
      builder: (context, state) {
        var cubit = StepsCubit.get(context);
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
                        width: 80,
                        height: 40,
                        color: Color.fromARGB(255, 187, 224, 255),
                        child: Center(
                          child: Text(
                            'Steps',
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Total Number Of Steps',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${cubit.getsumSteps()}',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal),
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
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                            'Steps are useful measure of how much you\'re moving around, and can help you spot changes in your activity levels'),
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
