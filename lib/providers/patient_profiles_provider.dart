import 'package:nars/api/patient_api.dart';
import 'package:nars/enumerables/home_state.dart';
import 'package:nars/models/patient/profile.dart';
import 'package:flutter/material.dart';

class PatientProfilesProvider extends ChangeNotifier {
  HomeState _homeState = HomeState.Initial;
  List<Profile> profiles = [];
  String message = '';

  PatientProfilesProvider() {
    _fetchProfiles();
  }

  HomeState get homeState => _homeState;

  Future<void> _fetchProfiles() async {
    _homeState = HomeState.Loading;
    try {
      final apiProfiles = await ProfileApi.getProfiles();
      // await Future.delayed(const Duration(seconds: 2));
      profiles = apiProfiles;
      _homeState = HomeState.Loaded;
    } catch (e) {
      message = '$e';
      _homeState = HomeState.Error;
      // throw e;
    }
    notifyListeners();
  }

  // void deleteSpecialization(Specialization specialization, bool isDeleted) {
  //   specializations.firstWhere((x) => x.id == specialization.id).isDeleted =
  //       isDeleted;
  //   notifyListeners();
  // }
}
