import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/layout/cubit/cubit.dart';
import 'package:fristapp/layout/cubit/states.dart';
import 'package:fristapp/modules/login/cubit/cubit.dart';
import 'package:fristapp/modules/login/login_screen.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:fristapp/shared/component/constants.dart';
import 'package:fristapp/shared/network/local/cache_helper.dart';

class Settingsscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GPCubit, GPStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GPCubit.get(context);
        var usermodel = cubit.usermodel;
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 190.0,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        child: Container(
                          height: 150.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                10.0,
                              ),
                              topRight: Radius.circular(
                                10.0,
                              ),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                '${usermodel!.cover}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        alignment: AlignmentDirectional.topCenter,
                      ),
                      Align(
                        child: CircleAvatar(
                          radius: 55.0,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundImage: NetworkImage(
                              '${usermodel.image}',
                            ),
                          ),
                        ),
                        alignment: AlignmentDirectional.bottomStart,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${usermodel.name}',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    color: defultColor,
                                  ),
                        ),
                        Text(
                          '${usermodel.email}',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.0,
                ),
                MyDivider(),
                SizedBox(
                  height: 14.0,
                ),
                Container(
                  height: 20.0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Dark Mode',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
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
                ),
                SizedBox(
                  height: 14.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {
                            NavidetAndFinish(context, LoginScreen());
                            CachHelper.removeData(key: 'uId');
                            cubit.currentIndex = 0;
                          },
                          child: Text(
                            'Log Out',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                      color: defultColor,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Delete Account'),
                              content: const Text(
                                'Erase all your data',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    cubit.UserDeleteAccount();
                                    NavidetAndFinish(context, LoginScreen());
                                    CachHelper.removeData(key: 'uId');
                                    cubit.currentIndex = 0;
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ),
                          child: Text(
                            'Delete Your Account',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
