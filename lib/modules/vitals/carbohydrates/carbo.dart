import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/carbohydrates/cubit/cubit.dart';
import 'package:fristapp/modules/vitals/carbohydrates/cubit/states.dart';
import 'package:fristapp/shared/styles/icon_broken.dart';
import 'package:intl/intl.dart';

import '../../../layout/cubit/cubit.dart';
import '../../../shared/component/component.dart';
import '../../../shared/styles/MyIcon.dart.dart';
import 'addNewValueCarbo.dart';

class CarboRate extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarboCubit, CarboStates>(
      listener: (context, state) {
        if (state is CarboAddedToGoogleFitSuccessState) {
          showToast(
              msg: 'Value added Successfully', state: toastStates.SUCCESS);
        }
      },
      builder: (context, state) {
        var cubit = CarboCubit.get(context);
        return DefaultTabController(
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    NavigetTo(context, AddNewValueCarbo());
                  },
                  icon: Padding(
                    padding: const EdgeInsets.only(
                      right: 30.0,
                    ),
                    child: Icon(Icons.add),
                  ),
                )
              ],
              title: Text(
                "Carbohydrates",
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
