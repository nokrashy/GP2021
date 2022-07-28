import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/layout/home_layout.dart';
import 'package:fristapp/modules/login/login_screen.dart';
import 'package:fristapp/shared/component/component.dart';
import 'package:fristapp/shared/network/local/cache_helper.dart';
import '../../shared/styles/MyIcon.dart.dart';
import '../../shared/styles/icon_broken.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var weightController = TextEditingController();
  var heightController = TextEditingController();
  var emergencyEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterErrorState) {
            showToast(
              msg: state.error,
              state: toastStates.ERROR,
            );
          }
          if (state is RegisterSuccessState) {
            CachHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              NavidetAndFinish(context, LoginScreen());
            });
          }
        },
        builder: (context, state) {
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
                          'REGISTER',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'Register now to follow your health',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your name';
                            }
                          },
                          lable: 'User Name',
                          prefix: Icons.person,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          lable: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: RegisterCubit.get(context).suffix,
                          onSubmit: (value) {},
                          obsCuretext: RegisterCubit.get(context).isPassword,
                          onPressed: () {
                            RegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          lable: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your emergency phone number';
                            }
                            if (value.length != 11 ||
                                value.substring(0, 2) != '01') {
                              print(value.substring(0, 2) != '01');
                              return 'enter a valid phone number';
                            }
                          },
                          lable: 'Emergency Number',
                          prefix: Icons.phone,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defultFormField(
                          controller: emergencyEmailController,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your emergency email';
                            }
                          },
                          lable: 'Emergency Email',
                          prefix: IconBroken.Heart,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defultFormField(
                          controller: weightController,
                          type: TextInputType.number,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your weight';
                            }
                          },
                          lable: 'Weight',
                          prefix: MyIcon.weight,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defultFormField(
                          controller: heightController,
                          type: TextInputType.number,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your Height';
                            }
                          },
                          lable: 'Height',
                          prefix: IconBroken.Filter,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (context) => defulteButton(
                            function: () async {
                              if (formKey.currentState!.validate()) {
                                RegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                  height: heightController.text,
                                  weight: weightController.text,
                                  emergency_email:
                                      emergencyEmailController.text,
                                );
                              }
                            },
                            text: 'register',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
