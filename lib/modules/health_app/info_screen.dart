import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/layout/cubit/cubit.dart';
import 'package:fristapp/layout/cubit/states.dart';
import 'package:fristapp/modules/vitals/Calories/energy_burned.dart';
import 'package:fristapp/modules/vitals/heart_rate/heart_rate.dart';
import 'package:fristapp/modules/vitals/steps/total_steps.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:fristapp/shared/styles/MyIcon.dart.dart';
import 'package:fristapp/shared/styles/icon_broken.dart';

import '../vitals/blood_glucose/blood_glucose.dart';
import '../vitals/height/height.dart';
import '../vitals/weight/weight.dart';

class Infoscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GPCubit, GPStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GPCubit.get(context);
        return Scaffold(
          body: Material(
            color: cubit.IsDark ? Colors.grey[800] : Colors.white,
            child: RefreshIndicator(
              onRefresh: cubit.refreshandfetch,
              child: Container(
                color: Colors.grey[200],
                child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 10),
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 1,
                        // crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 4 / 2,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print('*************************');
                              NavigetTo(context, GlucoseRate());
                            },
                            child: InfoCard(
                              title: 'Blood Glucose',
                              content: 'mmol/L',
                              icon: IconBroken.User,
                              isPrimaryColor: false,
                              context: context,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              NavigetTo(context, HeartRate());
                            },
                            child: InfoCard(
                              title: 'Heart Rate',
                              content: 'Beats per minute',
                              icon: IconBroken.Heart,
                              isPrimaryColor: false,
                              context: context,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              NavigetTo(context, TotalSteps());
                            },
                            child: InfoCard(
                              title: 'Steps',
                              content: 'Count',
                              icon: MyIcon.walking,
                              isPrimaryColor: false,
                              context: context,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              NavigetTo(context, EnergyBurned());
                            },
                            child: InfoCard(
                              title: 'Energy Burned',
                              content: 'Calories',
                              icon: IconBroken.Scan,
                              isPrimaryColor: false,
                              context: context,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              // print('*************************');
                              print('Height');
                              // print(cubit.lastDateHeight!.value);
                              // print('*************************');
                              NavigetTo(context, Height());
                            },
                            child: InfoCard(
                              title: 'Height',
                              content: 'Centimeters ',
                              icon: IconBroken.Filter,
                              isPrimaryColor: false,
                              context: context,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              
                              NavigetTo(context, Weight());
                            },
                            child: InfoCard(
                              title: 'Weight',
                              content: 'Kg',
                              icon: MyIcon.weight,
                              isPrimaryColor: false,
                              context: context,
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     // NavigetTo(context, BloodOxygen());
                          //   },
                          //   child: InfoCard(
                          //     title: 'SpO2',
                          //     content: 'Percentage',
                          //     icon: MyIcon.pan_tool,
                          //     isPrimaryColor: false,
                          //     context: context,
                          //   ),
                          // ),
                          // GestureDetector(
                          //   onTap: () {
                          //     print('*************************');
                          //     print('Body Temperatur');
                          //     print(cubit.lastDateBodyTemperatur!.value);
                          //     print('*************************');

                          //   },
                          //   child: InfoCard(
                          //     title: 'Body Temperature',
                          //     content: '°C',
                          //     icon: MyIcon.temperatire,
                          //     isPrimaryColor: false,
                          //     context: context,
                          //   ),
                          // ),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
