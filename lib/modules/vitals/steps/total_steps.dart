import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/steps/cubit/cubit.dart';
import 'package:fristapp/modules/vitals/steps/cubit/states.dart';
import 'package:fristapp/shared/network/local/sqldb.dart';
import 'package:health/health.dart';

class TotalSteps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => StepsCubit(),
      child: BlocConsumer<StepsCubit, StepsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = StepsCubit.get(context);
          return DefaultTabController(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "My steps",
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
                    print(index);
                  },
                ),
              ),
              body: cubit.screenss[cubit.tabIndex],
            ),
            initialIndex: cubit.tabIndex,
            length: 2,
          );
        },
      ),
    );
  }
}
