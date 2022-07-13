import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/heart_rate/cubit/cubit.dart';
import 'package:fristapp/modules/vitals/heart_rate/cubit/states.dart';
import 'package:fristapp/shared/component/constants.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:fristapp/shared/styles/icon_broken.dart';

class HeartRate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HrCubit, HrStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HrCubit.get(context);
        return DefaultTabController(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Heart Rate",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                ),
              ),
              bottom: TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.blue,
                tabs: cubit.tabs,
                onTap: (index) {
                  cubit.changetopNavBar(index);
                },
              ),
            ),
            body: cubit.screenss[cubit.tabIndex],
          ),
          initialIndex: cubit.tabIndex,
          length: 2,
        );
      },
    );
  }
}
