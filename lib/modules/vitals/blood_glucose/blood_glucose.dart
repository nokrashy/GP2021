import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/blood_glucose/cubit/cubit.dart';
import 'package:fristapp/modules/vitals/blood_glucose/cubit/states.dart';

class GlucoseRate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GlucoseCubit, GlucoseStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GlucoseCubit.get(context);
        return DefaultTabController(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Blood Glucose",
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
