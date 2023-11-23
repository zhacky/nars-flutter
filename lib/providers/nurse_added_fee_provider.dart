import 'package:nars/api/nurse_added_fee_api.dart';
import 'package:nars/enumerables/home_state.dart';
import 'package:nars/models/nurse_added_fee/nurse_added_fee.dart';
import 'package:flutter/material.dart';

class NurseAddedFeeProvider extends ChangeNotifier {
  HomeState _homeState = HomeState.Initial;
  List<NurseAddedFee> nurseAddedFees = [];
  String message = '';

  NurseAddedFeeProvider() {
    _fetchNurseAddedFees();
  }

  HomeState get homeState => _homeState;

  Future<void> _fetchNurseAddedFees() async {
    _homeState = HomeState.Loading;
    try {
      final apiNurseAddedFee = await NurseAddedFeeApi.getNurseAddedFees();
      // await Future.delayed(const Duration(seconds: 2));
      nurseAddedFees = apiNurseAddedFee;
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
