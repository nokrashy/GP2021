import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

abstract class GPStates {}

class InitialState extends GPStates {}

class BottomNavState extends GPStates {}

class AppChangeModeState extends GPStates {}

class GetUserLoadingState extends GPStates {}

class GetUserSuccessState extends GPStates {}
class GetUserErrorState extends GPStates {
  final String error;
  GetUserErrorState(this.error);
}


//
class UserDeleteAccountLoadingState extends GPStates {}

class UserDeleteAccountSuccessState extends GPStates {}

class UserDeleteAccountErrorState extends GPStates {
  late final String Error;
  UserDeleteAccountErrorState(this.Error);
}

//
