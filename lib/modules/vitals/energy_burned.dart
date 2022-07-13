import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/layout/cubit/cubit.dart';
import 'package:fristapp/layout/cubit/states.dart';
import 'package:fristapp/shared/component/constants.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:fristapp/shared/styles/icon_broken.dart';

class EnergyBurned extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GPCubit, GPStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GPCubit.get(context);
        var today = cubit.lastDateEnergyBurned!.dateFrom;
        String dateSlug =
            "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year.toString()}";
        String timeSlug =
            "${today.hour.toString()}:${today.minute.toString().padLeft(2, '0')}";

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(IconBroken.Arrow___Left_2),
            ),
            title: Text(
              'Energy Burned',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          body: tempitembuilder(
            value: cubit.lastDateEnergyBurned!.value.round(),
            date: dateSlug,
            time: timeSlug,
          ),
        );
      },
    );
  }
}
