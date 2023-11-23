import 'package:nars/api/specialization_api.dart';
import 'package:nars/enumerables/home_state.dart';
import 'package:nars/models/practitioner/practitioner_specialization.dart';
import 'package:nars/models/specialization/specialization.dart';
import 'package:flutter/material.dart';

class SpecializationsProvider extends ChangeNotifier {
  HomeState _homeState = HomeState.Initial;
  List<Specialization> specializations = [];
  String message = '';

  SpecializationsProvider(int? practitionerId) {
    _fetchSpecializations(practitionerId);
  }

  HomeState get homeState => _homeState;

  Future<void> _fetchSpecializations(int? practitionerId) async {
    _homeState = HomeState.Loading;
    try {
      List<PractitionerSpecialization> apiPractitionerSpecializations = [];
      var ids;
      final apiSpecializations = await SpecializationApi.getSpecializations();
      if (practitionerId != null) {
        ids = (apiPractitionerSpecializations =
                await SpecializationApi.getPractitionerSpecializations(
                    practitionerId))
            .map((e) => e.specialityId);
        // print('ids');
        // print(ids);
        // ids = apiPractitionerSpecializations.map((e) => e.id);
        // print('apiPractitionerSpecializations');
        // print(apiPractitionerSpecializations.first.specialityName);
      }
      if (practitionerId != null) {
        apiSpecializations.forEach((x) {
          // print(x.id);
          // print('ids');
          // print(ids);
          if (ids.contains(x.id)) {
            // print(x.name);
            x.isSelected = true;
          }
        });
      }

      specializations = apiSpecializations;
      _homeState = HomeState.Loaded;
    } catch (e) {
      message = '$e';
      _homeState = HomeState.Error;
      // throw e;
    }
    notifyListeners();
  }

  int? filterSpecialization(Specialization specialization) {
    var selected =
        specializations.where((x) => x.isSelected && x.id != specialization.id);

    if (selected.isNotEmpty) {
      selected.first.isSelected = false;
    }
    var isSelected =
        specializations.firstWhere((x) => x.id == specialization.id);
    isSelected.isSelected = !isSelected.isSelected;

    notifyListeners();

    if (isSelected.isSelected) {
      return specialization.id;
    } else {
      return null;
    }
  }

  void selectSpecialization(Specialization specialization) {
    var selected = specializations.firstWhere((x) => x.id == specialization.id);
    selected.isSelected = !selected.isSelected;
    notifyListeners();
  }

  void deleteSpecialization(Specialization specialization, bool isDeleted) {
    specializations.firstWhere((x) => x.id == specialization.id).isDeleted =
        isDeleted;
    notifyListeners();
  }
}
