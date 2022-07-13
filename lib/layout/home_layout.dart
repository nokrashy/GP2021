import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/layout/cubit/cubit.dart';
import 'package:fristapp/layout/cubit/states.dart';
import 'package:fristapp/shared/component/constants.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:fristapp/shared/styles/icon_broken.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GPCubit, GPStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GPCubit.get(context);
        var usermodel = cubit.usermodel;

        return Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            title: Center(
              child: Text(
                "${cubit.appBartitle[cubit.currentIndex]}",
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: defultColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            // actions: [
            //   IconButton(
            //     onPressed: () {
            //       if (usermodel != null) {
            //         print('hello');
            //         print(usermodel.email);
            //         print(usermodel.name);
            //         print(usermodel.phone);
            //         print(usermodel.uId);
            //         print(usermodel.cover);
            //       }
            //     },
            //     icon: Icon(
            //       IconBroken.Show,
            //     ),
            //   ),
            // ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNavBar(index);
            },
            items: cubit.bottomItems,
          ),
        );
      },
    );
  }
}
