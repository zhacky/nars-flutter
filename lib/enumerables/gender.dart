import 'package:nars/helpers/helpers.dart';

enum Gender {
  Male,
  Female,
}

final genderValues = EnumValuesByInt(
  {
    0: Gender.Male,
    1: Gender.Female,
  },
);
