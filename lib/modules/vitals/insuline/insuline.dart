import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/modules/vitals/insuline/addNewValueInsuline.dart';
import 'package:fristapp/modules/vitals/insuline/cubit/cubit.dart';
import 'package:fristapp/modules/vitals/insuline/cubit/states.dart';
import '../../../shared/component/component.dart';

class insulinRate extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<insulinCubit, insulinStates>(
      listener: (context, state) {
        if (state is insulinAddedToGoogleFitSuccessState) {
          showToast(
              msg: 'Value added Successfully', state: toastStates.SUCCESS);
        }
      },
      builder: (context, state) {
        var cubit = insulinCubit.get(context);
        return DefaultTabController(
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    NavigetTo(context, AddNewValueinsulin());
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
                "Insulin",
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
