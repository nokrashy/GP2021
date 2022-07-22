import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/layout/cubit/cubit.dart';
import 'package:fristapp/shared/component/component.dart';
import '../../layout/cubit/states.dart';

class ResetScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = GPCubit.get(context);
    return BlocProvider(
      create: (context) => GPCubit(),
      child: BlocConsumer<GPCubit, GPStates>(
          listener: (context, State) {},
          builder: (context, State) {
            return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reset Your Password',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            defultFormField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              validate: (Value) {
                                if (Value!.isEmpty) {
                                  return 'please enter your email address';
                                }
                                return null;
                              },
                              lable: 'Email Adress',
                              prefix: Icons.email_outlined,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            ConditionalBuilder(
                              condition: State is! ResetLoadingState,
                              builder: (context) => defulteButton(
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit
                                        .resetPassword(
                                            email: emailController.text,
                                            context: context)
                                        .then((value) {
                                      showToast(
                                          msg: value.toString(),
                                          state: toastStates.SUCCESS);
                                      print(value);
                                    }).catchError((e) {
                                      showToast(
                                          msg: e.toString(),
                                          state: toastStates.ERROR);
                                      print(e);
                                    });
                                  }
                                },
                                text: 'Send Email',
                              ),
                              fallback: (context) =>
                                  Center(child: CircularProgressIndicator()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          }),
    );
  }
}
