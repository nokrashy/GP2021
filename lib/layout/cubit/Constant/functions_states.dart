import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

abstract class ConstantFunctinsStates {}
class InitialState extends ConstantFunctinsStates {}


// ******************************      Feych From Google Fit Functions     ******************************
// fetch Steps
class StepsStartFetchedState extends ConstantFunctinsStates {}

class StepsNotFetchedState extends ConstantFunctinsStates {}

class StepsFetchedSucessfullyState extends ConstantFunctinsStates {}

class StepsAuthorizationNotGrantedState extends ConstantFunctinsStates {}

// fetch Heart Rate
class HrStartFetchedState extends ConstantFunctinsStates {}

class HrNotFetchedState extends ConstantFunctinsStates {}

class HrFetchedSucessfullyState extends ConstantFunctinsStates {}

class HrAuthorizationNotGrantedState extends ConstantFunctinsStates {}

// fetch calories
class caloriesStartFetchedState extends ConstantFunctinsStates {}

class caloriesNotFetchedState extends ConstantFunctinsStates {}

class caloriesFetchedSucessfullyState extends ConstantFunctinsStates {}

class caloriesAuthorizationNotGrantedState extends ConstantFunctinsStates {}

// fetch Weight
class WeightStartFetchedState extends ConstantFunctinsStates {}

class WeightNotFetchedState extends ConstantFunctinsStates {}

class WeightFetchedSucessfullyState extends ConstantFunctinsStates {}

class WeightAuthorizationNotGrantedState extends ConstantFunctinsStates {}

//  fetch Height
class HeightStartFetchedState extends ConstantFunctinsStates {}

class HeightNotFetchedState extends ConstantFunctinsStates {}

class HeightFetchedSucessfullyState extends ConstantFunctinsStates {}

class HeightAuthorizationNotGrantedState extends ConstantFunctinsStates {}

// fetch Glucose
class GlucoseStartFetchedState extends ConstantFunctinsStates {}

class GlucoseNotFetchedState extends ConstantFunctinsStates {}

class GlucoseFetchedSucessfullyState extends ConstantFunctinsStates {}

class GlucoseAuthorizationNotGrantedState extends ConstantFunctinsStates {}

// fetch Blood Oxygen =>Insuline
class FatInsulineStartFetchedState extends ConstantFunctinsStates {}

class FatInsulineNotFetchedState extends ConstantFunctinsStates {}

class FatInsulineFetchedSucessfullyState extends ConstantFunctinsStates {}

class FatInsulineAuthorizationNotGrantedState extends ConstantFunctinsStates {}

 // Fetch Carbohydrates => Bode_temperature
class TemperatureCarbohydratesStartFetchedState extends ConstantFunctinsStates {}

class TemperatureCarbohydratesNotFetchedState extends ConstantFunctinsStates {}

class TemperatureCarbohydratesFetchedSucessfullyState extends ConstantFunctinsStates {}

class TemperatureCarbohydratesAuthorizationNotGrantedState extends ConstantFunctinsStates {}
