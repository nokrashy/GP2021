import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/layout/cubit/cubit.dart';
import 'package:fristapp/layout/cubit/states.dart';
import 'package:fristapp/shared/component/constants.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:fristapp/shared/styles/icon_broken.dart';

class Weight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GPCubit, GPStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GPCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(IconBroken.Arrow___Left_2),
            ),
            title: Text(
              'Weight',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          // body: tempitembuilder(
          //   value: (cubit.lastDateBloodOxygen!.value.isNaN)
          //       ? cubit.lastDateBloodOxygen!.value.round()
          //       : 0,
          //   date: dateSlug,
          //   time: timeSlug,
          // ),
        );
      },
    );
  }
}
