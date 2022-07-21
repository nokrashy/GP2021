import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/Calories/cubit/cubit.dart';
import 'package:fristapp/modules/vitals/Calories/cubit/states.dart';

class DateCalori extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CaloriCubit, CaloriStates>(
      listener: (context, state) {
        if (state is ChangeTopNavBartoDaysState) {
          CaloriCubit.get(context).getsumCalori();
        }
      },
      builder: (context, state) {
        var cubit = CaloriCubit.get(context);
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
                        width: 160,
                        height: 40,
                        color: Color.fromARGB(255, 187, 224, 255),
                        child: Center(
                          child: Text(
                            'Energy Burned',
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
                                  'Total Energy Burned',
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
                                  '${cubit.getsumCalori()}',
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
                            'The body uses energy for more than just workouts.\nYou\'ll see an estimate of your total calories burned while active, and also at rest.'),
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
