// ******************************      Feych From Google Fit Functions     ******************************

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'functions_states.dart';

class ConstantFunctinsCubit extends Cubit<ConstantFunctinsStates> {
  ConstantFunctinsCubit() : super(InitialState());
  static ConstantFunctinsCubit get(context) => BlocProvider.of(context);

  HealthFactory health = HealthFactory();

// Fetch Steps
  Future fetchSteps({required final from, required final to}) async {
    emit(StepsStartFetchedState());
    List<HealthDataPoint> stepsHealthDataList = [];
    bool requested = await health.requestAuthorization([HealthDataType.STEPS],
        permissions: [HealthDataAccess.READ]);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health
            .getHealthDataFromTypes(from, to, [HealthDataType.STEPS]);
        stepsHealthDataList.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      stepsHealthDataList = HealthFactory.removeDuplicates(stepsHealthDataList);
      if (stepsHealthDataList.isEmpty) {
        emit(StepsNotFetchedState());
      } else {
        emit(StepsFetchedSucessfullyState());
      }
    } else {
      print("Authorization not granted");
      emit(StepsAuthorizationNotGrantedState());
    }
    return stepsHealthDataList;
  }

  // Fetch Heart Rate
  Future fetchHeartRate({required final from, required final to}) async {
    emit(HrStartFetchedState());
    List<HealthDataPoint> heartRateDataList = [];
    bool requested = await health.requestAuthorization(
        [HealthDataType.HEART_RATE],
        permissions: [HealthDataAccess.READ]);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health
            .getHealthDataFromTypes(from, to, [HealthDataType.HEART_RATE]);
        heartRateDataList.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      heartRateDataList = HealthFactory.removeDuplicates(heartRateDataList);

      if (heartRateDataList.isEmpty) {
        emit(HrNotFetchedState());
      } else {
        emit(HrFetchedSucessfullyState());
      }
    } else {
      emit(HrAuthorizationNotGrantedState());
    }

    return heartRateDataList;
  }

  // fetch calories
  Future fetchCalories({required final from, required final to}) async {
    emit(caloriesStartFetchedState());
    List<HealthDataPoint> caloriesDataList = [];
    bool requested = await health.requestAuthorization(
        [HealthDataType.ACTIVE_ENERGY_BURNED],
        permissions: [HealthDataAccess.READ]);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
            from, to, [HealthDataType.ACTIVE_ENERGY_BURNED]);
        caloriesDataList.addAll(healthData);
        print(caloriesDataList);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      caloriesDataList = HealthFactory.removeDuplicates(caloriesDataList);

      if (caloriesDataList.isEmpty) {
        emit(caloriesNotFetchedState());
      } else {
        emit(caloriesFetchedSucessfullyState());
      }
    } else {
      emit(caloriesAuthorizationNotGrantedState());
    }
    return caloriesDataList;
  }

  // fetch Weight
  Future fetchWeight({required final from, required final to}) async {
    emit(WeightStartFetchedState());
    List<HealthDataPoint> WeightDataList = [];
    bool requested = await health.requestAuthorization([HealthDataType.WEIGHT],
        permissions: [HealthDataAccess.READ]);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health
            .getHealthDataFromTypes(from, to, [HealthDataType.WEIGHT]);
        WeightDataList.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      WeightDataList = HealthFactory.removeDuplicates(WeightDataList);

      if (WeightDataList.isEmpty) {
        emit(WeightNotFetchedState());
      } else {
        emit(WeightFetchedSucessfullyState());
      }
    } else {
      print("Authorization not granted");
      emit(WeightAuthorizationNotGrantedState());
    }
    return WeightDataList;
  }

  // fetch Height
  Future fetchHeight({required final from, required final to}) async {
    emit(HeightStartFetchedState());
    List<HealthDataPoint> HeightDataList = [];
    bool requested = await health.requestAuthorization([HealthDataType.HEIGHT],
        permissions: [HealthDataAccess.READ]);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health
            .getHealthDataFromTypes(from, to, [HealthDataType.HEIGHT]);

        HeightDataList.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      HeightDataList = HealthFactory.removeDuplicates(HeightDataList);

      if (HeightDataList.isEmpty) {
        emit(HeightNotFetchedState());
      } else {
        emit(HeightFetchedSucessfullyState());
      }
    } else {
      print("Authorization not granted");
      emit(HeightAuthorizationNotGrantedState());
    }

    return HeightDataList;
  }

  // Fetch Blood_Glucose
  Future fetchBloodGlucose({required final from, required final to}) async {
    emit(GlucoseStartFetchedState());
    List<HealthDataPoint> glucoseDataList = [];
    bool requested = await health.requestAuthorization(
        [HealthDataType.BLOOD_GLUCOSE],
        permissions: [HealthDataAccess.READ]);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health
            .getHealthDataFromTypes(from, to, [HealthDataType.BLOOD_GLUCOSE]);
        glucoseDataList.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      glucoseDataList = HealthFactory.removeDuplicates(glucoseDataList);

      if (glucoseDataList.isEmpty) {
        emit(GlucoseNotFetchedState());
      } else {
        emit(GlucoseFetchedSucessfullyState());
      }
    } else {
      emit(GlucoseAuthorizationNotGrantedState());
    }

    return glucoseDataList;
  }

// Fetch Insuline => BODY_FAT_PERCENTAGE
  Future fetchFatInsuline({required final from, required final to}) async {
    emit(FatInsulineStartFetchedState());
    List<HealthDataPoint> fat_insulineDataList = [];
    bool requested = await health.requestAuthorization(
        [HealthDataType.BODY_FAT_PERCENTAGE],
        permissions: [HealthDataAccess.READ]);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
            from, to, [HealthDataType.BODY_FAT_PERCENTAGE]);
        fat_insulineDataList.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      fat_insulineDataList =
          HealthFactory.removeDuplicates(fat_insulineDataList);

      if (fat_insulineDataList.isEmpty) {
        emit(FatInsulineNotFetchedState());
      } else {
        emit(FatInsulineFetchedSucessfullyState());
      }
    } else {
      emit(FatInsulineAuthorizationNotGrantedState());
    }

    return fat_insulineDataList;
  }

  // Fetch Carbohydrates => Body_temperature
  Future fetchTemperaturCarbohydrates(
      {required final from, required final to}) async {
    emit(TemperatureCarbohydratesStartFetchedState());
    List<HealthDataPoint> temperatur_carbohydratesDataList = [];
    bool requested = await health.requestAuthorization(
        [HealthDataType.BODY_TEMPERATURE],
        permissions: [HealthDataAccess.READ]);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
            from, to, [HealthDataType.BODY_TEMPERATURE]);
        temperatur_carbohydratesDataList.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }
      temperatur_carbohydratesDataList =
          HealthFactory.removeDuplicates(temperatur_carbohydratesDataList);

      if (temperatur_carbohydratesDataList.isEmpty) {
        emit(TemperatureCarbohydratesNotFetchedState());
      } else {
        emit(TemperatureCarbohydratesFetchedSucessfullyState());
      }
    } else {
      emit(TemperatureCarbohydratesAuthorizationNotGrantedState());
    }

    return temperatur_carbohydratesDataList;
  }
  // ---------------------------------------------------------------------------
}
