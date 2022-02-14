import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/layout/cubit/cubit.dart';
import 'package:fristapp/layout/cubit/states.dart';
import 'package:fristapp/modules/login/login_screen.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:fristapp/shared/network/local/cache_helper.dart';

class Settingsscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GPCubit, GPStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GPCubit.get(context);

        return Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Switch(
                      value: GPCubit.get(context).IsDark,
                      onChanged: (value) {
                        GPCubit.get(context).ChangeAppMode();
                      },
                    ),
                  ],
                ),
                MyDivider(),
                SizedBox(
                  height: 14.0,
                ),
                defulteButton(
                    function: () {
                      NavidetAndFinish(context, LoginScreen());
                      CachHelper.removeData(key: 'uId');
                    },
                    text: 'Log Out'),
              ],
            ),
          ),
        );
      },
    );
  }
}
