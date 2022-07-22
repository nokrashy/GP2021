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

class UserDeleteAccountLoadingState extends GPStates {}

class UserDeleteAccountSuccessState extends GPStates {}

class UserDeleteAccountErrorState extends GPStates {
  late final String Error;
  UserDeleteAccountErrorState(this.Error);
}

class FetchingStepsFromGoogleFitState extends GPStates {}

class NoStepsFromGoogleFitState extends GPStates {}

class StepsReadyFromGoogleFitState extends GPStates {}

class StepsNotFetchedFromGoogleFitState extends GPStates {}

class DataAddedToGoogleFitSuccessState extends GPStates {}

class DataAddedToGoogleFitErrorState extends GPStates {}

class RefreshAndFetchDataState extends GPStates {}

// -----------------------------------------------------------------------------------------------------------

class StartConnecttoFitState extends GPStates {}

class ConnecttoFitSuccessState extends GPStates {}

class ConnecttoFitFailedsState extends GPStates {}

class HandlePhoneNumberSuccessState extends GPStates {}

class HandlePhoneNumbererrorState extends GPStates {}

// Handle model
class MOdelrSuccessState extends GPStates {}

class MOdelErrorState extends GPStates {}

class MOdelLoadingState extends GPStates {}

class ChangeisOnState extends GPStates {}

class ModelCycleSuccessState extends GPStates {
  final String val;
  ModelCycleSuccessState(this.val);
}

class ModelCycleErrorState extends GPStates {}

class ModelCycleOFFState extends GPStates {}

class GlucoseStartAddToGoogleFitSuccessState extends GPStates {}

class GlucoseAddedToGoogleFitSuccessState extends GPStates {}

class GlucoseAddedToGoogleFitErrorState extends GPStates {}

class GetLast15ErrorState extends GPStates {}

// Home Screen
class HomeScreenRefreshedState extends GPStates {}

// Settings Screen
class IsConnectedSTrueState extends GPStates {}

class IsConnectedFalseState extends GPStates {}

class ResetLoadingState extends GPStates {}

class ResetSuccessState extends GPStates {}

class ResetErrorState extends GPStates {}
