import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/Calories/cubit/cubit.dart';
import 'package:fristapp/modules/vitals/Calories/cubit/states.dart';

class EnergyBurned extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CaloriCubit(),
      child: BlocConsumer<CaloriCubit, CaloriStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CaloriCubit.get(context);
          return DefaultTabController(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "Energy Burned",
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
      ),
    );
  }
}
