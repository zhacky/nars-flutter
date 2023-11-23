import 'package:nars/api/practitioner_hospital_api.dart';
import 'package:nars/enumerables/days.dart';
import 'package:nars/enumerables/home_state.dart';
import 'package:nars/models/hospital/hospital_schedule.dart';
import 'package:nars/models/hospital/hospital_schedule_timespan.dart';
import 'package:nars/models/practitioner/practitioner_hospital.dart';
import 'package:flutter/material.dart';

class PractitionerHospitalProvider extends ChangeNotifier {
  HomeState _homeState = HomeState.Initial;
  late PractitionerHospital practitionerHospital;
  String message = '';

  PractitionerHospitalProvider(int? id) {
    _fetchPractitionerHospital(id);
  }

  HomeState get homeState => _homeState;

  Future<void> _fetchPractitionerHospital(int? id) async {
    _homeState = HomeState.Loading;
    try {
      if (id != null) {
        practitionerHospital =
            await PractitionerHospitalApi.getPractitionerHospital(id);
      } else {
        practitionerHospital = PractitionerHospital(
          hospitalSchedule: [
            HospitalSchedule(
              id: 1,
              day: 'Monday',
              hospitalScheduleTimeSpans: [
                HospitalScheduleTimeSpan(
                  id: 1,
                ),
              ],
            )
          ],
        );
      }

      // practitionerHospital = apiPractitionerHospital;
      _homeState = HomeState.Loaded;
    } catch (e) {
      message = '$e';
      _homeState = HomeState.Error;
      // throw e;
    }
    notifyListeners();
  }

  String? changeDay(int hSID, String? day) {
    var lHS = practitionerHospital.hospitalSchedule;
    var exist = lHS.any((x) => x.day == day);

    if (exist) {
      notifyListeners();
      return 'Day already exist';
    } else {
      lHS.firstWhere((x) => x.id == hSID).day = day;
      notifyListeners();
    }
  }

  void deleteDay(int hSID) {
    practitionerHospital.hospitalSchedule.removeWhere((x) => x.id == hSID);
    notifyListeners();
  }

  void changeStartTime(int hSID, int hSTSID, TimeOfDay start) {
    practitionerHospital.hospitalSchedule
        .firstWhere((x) => x.id == hSID)
        .hospitalScheduleTimeSpans
        .firstWhere((y) => y.id == hSTSID)
        .start = start;
    notifyListeners();
  }

  void changeEndTime(int hSID, int hSTSID, TimeOfDay end) {
    practitionerHospital.hospitalSchedule
        .firstWhere((x) => x.id == hSID)
        .hospitalScheduleTimeSpans
        .firstWhere((y) => y.id == hSTSID)
        .end = end;
    notifyListeners();
  }

  void addScheduleTimeSpan(int hSIS) {
    var hSTS = practitionerHospital.hospitalSchedule
        .firstWhere((x) => x.id == hSIS)
        .hospitalScheduleTimeSpans;

    var maxId = hSTS.last.id;

    hSTS.add(
      HospitalScheduleTimeSpan(id: maxId! + 1),
    );
    notifyListeners();
  }

  void deleteScheduleTimeSpan(int hSID, int hSTSID) {
    practitionerHospital.hospitalSchedule
        .firstWhere((x) => x.id == hSID)
        .hospitalScheduleTimeSpans
        .removeWhere((y) => y.id == hSTSID);
    notifyListeners();
  }

  void addDay() {
    var lHS = practitionerHospital.hospitalSchedule;

    String? available;
    int count = 0;

    for (String day in days) {
      if (!lHS.any((x) => x.day!.contains(day)) && available == null) {
        available = day;
      } else if (lHS.any((x) => x.day!.contains(day))) {
        count++;
      }
    }

    var maxId = lHS.last.id;

    if (count != days.length) {
      lHS.add(
        HospitalSchedule(
          id: maxId! + 1,
          day: available,
          hospitalScheduleTimeSpans: [
            HospitalScheduleTimeSpan(id: 1),
          ],
        ),
      );
    }
    if (count == days.length - 1) {
      practitionerHospital.allDayExist = true;
      // return 'All day already exist';
    }
    notifyListeners();
  }

  void deleteMode() {
    practitionerHospital.deleteMode = !practitionerHospital.deleteMode;
    notifyListeners();
  }
}
