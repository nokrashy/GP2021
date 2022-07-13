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

class FetchingDataFromGoogleFitState extends GPStates {}

class NoDataFromGoogleFitState extends GPStates {}

class DataReadyFromGoogleFitState extends GPStates {}

class DataNotFetchedFromGoogleFitState extends GPStates {}

class FetchingStepsFromGoogleFitState extends GPStates {}

class NoStepsFromGoogleFitState extends GPStates {}

class StepsReadyFromGoogleFitState extends GPStates {}

class StepsNotFetchedFromGoogleFitState extends GPStates {}

class DataAddedToGoogleFitSuccessState extends GPStates {}

class DataAddedToGoogleFitErrorState extends GPStates {}

class RefreshAndFetchDataState extends GPStates {}

// -----------------------------------------------------------------------------
// fetch data individually
// fetch Steps
class StepsStartFetchedState extends GPStates {}

class StepsNotFetchedState extends GPStates {}

class StepsFetchedSucessfullyState extends GPStates {}

class StepsAuthorizationNotGrantedState extends GPStates {}

// fetch Heart Rate
class HrStartFetchedState extends GPStates {}

class HrNotFetchedState extends GPStates {}

class HrFetchedSucessfullyState extends GPStates {}

class HrAuthorizationNotGrantedState extends GPStates {}

// fetch calories
class caloriesStartFetchedState extends GPStates {}

class caloriesNotFetchedState extends GPStates {}

class caloriesFetchedSucessfullyState extends GPStates {}

class caloriesAuthorizationNotGrantedState extends GPStates {}

// fetch Systolicpressure
class SystolicpressureStartFetchedState extends GPStates {}

class SystolicpressureNotFetchedState extends GPStates {}

class SystolicpressureFetchedSucessfullyState extends GPStates {}

class SystolicpressureAuthorizationNotGrantedState extends GPStates {}

//  fetch Diastolicpressure
class DiastolicpressureStartFetchedState extends GPStates {}

class DiastolicpressureNotFetchedState extends GPStates {}

class DiastolicpressureFetchedSucessfullyState extends GPStates {}

class DiastolicpressureAuthorizationNotGrantedState extends GPStates {}

// -----------------------------------------------------------------------------

class StartConnecttoFitState extends GPStates {}

class ConnecttoFitSuccessState extends GPStates {}

class ConnecttoFitFailedsState extends GPStates {}

class HandlePhoneNumberSuccessState extends GPStates {}

class HandlePhoneNumbererrorState extends GPStates {}

// Handle model
class MOdelrSuccessState extends GPStates {}

class MOdelErrorState extends GPStates {}

class MOdelLoadingState extends GPStates {}
