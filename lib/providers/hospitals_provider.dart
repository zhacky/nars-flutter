import 'package:nars/api/hospital_api.dart';
import 'package:nars/enumerables/home_state.dart';
import 'package:nars/models/hospital/hospital.dart';
import 'package:flutter/material.dart';

class HospitalsProvider extends ChangeNotifier {
  HomeState _homeState = HomeState.Initial;
  List<Hospital> hospitals = [];
  String message = '';

  HospitalsProvider() {
    _fetchHospitals();
  }

  HomeState get homeState => _homeState;

  Future<void> _fetchHospitals() async {
    _homeState = HomeState.Loading;
    try {
      final apiHospitals = await HospitalApi.getHospitals();
      // await Future.delayed(const Duration(seconds: 2));
      hospitals = apiHospitals;
      _homeState = HomeState.Loaded;
    } catch (e) {
      message = '$e';
      _homeState = HomeState.Error;
      // throw e;
    }
    notifyListeners();
  }

  int? filterHospital(Hospital hospital) {
    var selected = hospitals.where((x) => x.isSelected && x.id != hospital.id);

    if (selected.isNotEmpty) {
      selected.first.isSelected = false;
    }
    var isSelected = hospitals.firstWhere((x) => x.id == hospital.id);
    isSelected.isSelected = !isSelected.isSelected;

    notifyListeners();

    if (isSelected.isSelected) {
      return hospital.id;
    } else {
      return null;
    }
  }

  void selectHospital(Hospital hospital) {
    var selected = hospitals.firstWhere((x) => x.id == hospital.id);
    selected.isSelected = !selected.isSelected;
    notifyListeners();
  }

  void deleteHospital(Hospital hospital, bool isDeleted) {
    hospitals.firstWhere((x) => x.id == hospital.id).isDeleted = isDeleted;
    notifyListeners();
  }
}
