import 'package:nars/api/service_api.dart';
import 'package:nars/enumerables/home_state.dart';
import 'package:nars/models/practitioner/practitioner_service.dart';
import 'package:nars/models/service/service.dart';
import 'package:flutter/material.dart';

class ServicesProvider extends ChangeNotifier {
  HomeState _homeState = HomeState.Initial;
  List<Service> services = [];
  String message = '';

  ServicesProvider(int? practitionerId) {
    _fetchSpecializations(practitionerId);
  }

  HomeState get homeState => _homeState;

  Future<void> _fetchSpecializations(int? practitionerId) async {
    _homeState = HomeState.Loading;
    try {
      List<PractitionerService> apiPractitionerServices = [];
      var ids;
      final apiServices = await ServiceApi.getServices();
      if (practitionerId != null) {
        ids = (apiPractitionerServices =
                await ServiceApi.getPractitionerServices(practitionerId))
            .map((e) => e.serviceId);
        // print('ids');
        // print(ids);
        // ids = apiPractitionerSpecializations.map((e) => e.id);
        // print('apiPractitionerSpecializations');
        // print(apiPractitionerSpecializations.first.specialityName);
      }
      // services = apiServices;
      if (practitionerId != null) {
        apiServices.forEach((x) {
          // print(x.id);
          // print('ids');
          // print(ids);
          if (ids.contains(x.id)) {
            // print(x.name);
            x.isSelected = true;
          }
        });
      }

      services = apiServices;
      _homeState = HomeState.Loaded;
    } catch (e) {
      message = '$e';
      _homeState = HomeState.Error;
      // throw e;
    }
    notifyListeners();
  }

  int? filterServices(Service service) {
    var selected = services.where((x) => x.isSelected && x.id != service.id);

    if (selected.isNotEmpty) {
      selected.first.isSelected = false;
    }
    var isSelected = services.firstWhere((x) => x.id == service.id);
    isSelected.isSelected = !isSelected.isSelected;

    notifyListeners();

    if (isSelected.isSelected) {
      return service.id;
    } else {
      return null;
    }
  }

  void selectServices(Service service) {
    var selected = services.firstWhere((x) => x.id == service.id);
    selected.isSelected = !selected.isSelected;
    notifyListeners();
  }

  void deleteServices(Service service, bool isDeleted) {
    services.firstWhere((x) => x.id == service.id).isDeleted = isDeleted;
    notifyListeners();
  }
}
